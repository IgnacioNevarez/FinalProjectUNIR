//
//  ProfileController.swift
//  ProyectoFinal_IgnacioNevarez
//
//  Created by Ignacio Esau Nevarez on 03/01/21.
//

import LBTATools
import Alamofire

extension ProfileController: PostDelegate {
    func handleLike(post: Post) {
        
    }
    
    func showOptions(post: Post) {
        let alertController = UIAlertController(title: "Opciones", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(.init(title: "Eliminar post", style: .destructive, handler: { (_) in
            let url = "\(Service.shared.baseUrl)/post/\(post.id)"
            Alamofire.request(url, method: .delete)
                .validate(statusCode: 200..<300)
                .responseData { (dataResp) in
                    if let err = dataResp.error {
                        print("Failed to delete:", err)
                        return
                    }
                    
                    guard let index = self.items.firstIndex(where: {$0.id == post.id}) else { return }
                    self.items.remove(at: index)
                    self.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
        }))
        alertController.addAction(.init(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true)
    }
    
    func showComments(post: Post) {
        let postDetailsController = PostDetailsController(postId: post.id)
        navigationController?.pushViewController(postDetailsController, animated: true)
    }
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if user == nil {
            return .zero
        }
        
        return .init(width: 0, height: 300)
    }
}

class ProfileController: LBTAListHeaderController<UserPostCell, Post, ProfileHeader> {
    
    func handleFollowUnfollow() {
        guard let user = user else { return }
        let isFollowing = user.isFollowing == true
        let url = "\(Service.shared.baseUrl)/\(isFollowing ? "unfollow" : "follow")/\(user.id)"

        Alamofire.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    print("Failed to unfollow:", err)
                    return
                }

                self.user?.isFollowing = !isFollowing
                self.collectionView.reloadData()
        }
    }
    
    override func setupHeader(_ header: ProfileHeader) {
        super.setupHeader(header)
        
        if user == nil { return }
        
        header.user = self.user
        header.profileController = self
    }
    
    let userId: String
    
    init(userId: String) {
        self.userId = userId
        super.init()
    }
    
    fileprivate let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.startAnimating()
        aiv.color = .darkGray
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserProfile()
        
        setupActivityIndicatorView()
    }
    
    fileprivate func setupActivityIndicatorView() {
        collectionView.addSubview(activityIndicatorView)
        activityIndicatorView.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 100, left: 0, bottom: 0, right: 0))
    }
    
    var user: User?
    
    func fetchUserProfile() {
        let currentUserProfileUrl = "\(Service.shared.baseUrl)/profile"
        let publicProfileUrl = "\(Service.shared.baseUrl)/user/\(userId)"
        
        let url = self.userId.isEmpty ? currentUserProfileUrl : publicProfileUrl
        
        Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                self.activityIndicatorView.stopAnimating()
                
                if let err = dataResp.error {
                    print("Failed to fetch user profile:", err)
                    return
                }
                
                let data = dataResp.data ?? Data()
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.user = user
                    
                    self.user?.isEditable = self.userId.isEmpty
                    
                    self.items = user.posts ?? []
                    self.collectionView.reloadData()
                } catch {
                    print("Failed to decode user:", error)
                }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
