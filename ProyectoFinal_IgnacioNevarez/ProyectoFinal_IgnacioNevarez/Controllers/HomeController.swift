//
//  HomeController.swift
//  ProyectoFinal_IgnacioNevarez
//
//  Created by Ignacio Esau Nevarez on 03/01/21.
//

import LBTATools
import WebKit
import Alamofire
import SDWebImage

extension HomeController: PostDelegate {
    
    func handleLike(post: Post) {
        
        let hasLiked = post.hasLiked == true
                
        let string = hasLiked ? "dislike" : "like"
        let url = "\(Service.shared.baseUrl)/\(string)/\(post.id)"
        Alamofire.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                
                //completion
                
                guard let indexOfPost = self.items.firstIndex(where: {$0.id == post.id}) else { return }
                self.items[indexOfPost].hasLiked?.toggle()
                let indexPath = IndexPath(item: indexOfPost, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
        }
        
    }
    
    func showOptions(post: Post) {
        let alertController = UIAlertController(title: "Opciones", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(.init(title: "Remover del feed", style: .destructive, handler: { (_) in
            let url = "\(Service.shared.baseUrl)/feeditem/\(post.id)"
            Alamofire.request(url, method: .delete)
                .validate(statusCode: 200..<300)
                .responseData { (dataResp) in
                    if let err = dataResp.error {
                        print("Failed to delete:", err)
                        return
                    }
                    
                    guard let index = self.items.firstIndex(where: {$0.id == post.id}) else { return }
                    self.items.remove(at: index)
                    self.collectionView.deleteItems(at: [[0, index]])
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

class HomeController: LBTAListController<UserPostCell, Post>, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts()
        
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.rightBarButtonItems = [
            .init(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(handleSearch))
        ]
        
        navigationItem.leftBarButtonItem = .init(title: "Ingresar / Cambiar de sesión", style: .plain, target: self, action: #selector(handleLogin))
        
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
        self.collectionView.refreshControl = rc
    }
    
    @objc fileprivate func handleSearch() {
        let navController = UINavigationController(rootViewController: UsersSearchController())
        present(navController, animated: true)
    }
    
    @objc fileprivate func handleLogin() {
        print("Show login and sign up pages")
        let navController = UINavigationController(rootViewController: LoginController())
        present(navController, animated: true)
    }
    
    @objc func fetchPosts() {
        Service.shared.fetchPosts { (res) in
            self.collectionView.refreshControl?.endRefreshing()
            switch res {
            case .failure(let err):
                print("Failed to fetch posts:", err)
            case .success(let posts):
                self.items = posts
                self.collectionView.reloadData()
            }
        }
    }

}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)
        
        return .init(width: view.frame.width, height: height)
    }
}
