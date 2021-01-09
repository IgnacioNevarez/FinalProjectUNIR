//
//  ProfileHeader.swift
//  ProyectoFinal_IgnacioNevarez
//
//  Created by Ignacio Esau Nevarez on 03/01/21.
//

import LBTATools

class ProfileHeader: UICollectionReusableView {
    
    let profileImageView = CircularImageView(width: 80, image: #imageLiteral(resourceName: "user"))
    
    let followButton = UIButton(title: "Seguir", titleColor: .black, font: .boldSystemFont(ofSize: 13), target: self, action: #selector(handleFollow))
    
    let editProfileButton = UIButton(title: "Cambiar foto", titleColor: .white, font: .boldSystemFont(ofSize: 13), backgroundColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), target: self, action: #selector(handleEditProfile))
    
    let postsCountLabel = UILabel(text: "12", font: .boldSystemFont(ofSize: 14), textAlignment: .center)
    let postsLabel = UILabel(text: "posts", font: .systemFont(ofSize: 13), textColor: .lightGray, textAlignment: .center)
    
    let followersCountLabel = UILabel(text: "500", font: .boldSystemFont(ofSize: 14), textAlignment: .center)
    let followersLabel = UILabel(text: "seguidores", font: .systemFont(ofSize: 13), textColor: .lightGray, textAlignment: .center)
    
    let followingCountLabel = UILabel(text: "500", font: .boldSystemFont(ofSize: 14), textAlignment: .center)
    let followingLabel = UILabel(text: "siguiendo", font: .systemFont(ofSize: 13), textColor: .lightGray, textAlignment: .center)
    
    let fullNameLabel = UILabel(text: "Usuario", font: .boldSystemFont(ofSize: 14))
    let bioLabel = UILabel(text: "Esta es una pelicula de culto que definitivamente capturara tu atención.", font: .systemFont(ofSize: 13), textColor: .darkGray, numberOfLines: 0)
    
    weak var profileController: ProfileController?
    
    @objc fileprivate func handleEditProfile() {
        profileController?.changeProfileImage()
    }
    
    @objc fileprivate func handleFollow() {
        profileController?.handleFollowUnfollow()
    }
    
    var user: User! {
        didSet {
            profileImageView.sd_setImage(with: URL(string: user.profileImageUrl ?? ""))
            fullNameLabel.text = user.fullName
            
            bioLabel.text = user.bio
            
            followButton.setTitle(user.isFollowing == true ? "Unfollow" : "Follow", for: .normal)
            followButton.backgroundColor = user.isFollowing == true ? .black : .white
            followButton.setTitleColor(user.isFollowing == true ? .white : .black, for: .normal)
            
            if user.isEditable == true {
                followButton.removeFromSuperview()
            } else {
                editProfileButton.removeFromSuperview()
            }
            
            postsCountLabel.text = "\(user.posts?.count ?? 0)"
            followersCountLabel.text = "\(user.followers?.count ?? 0)"
            followingCountLabel.text = "\(user.following?.count ?? 0)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEditProfile)))
        
        followButton.layer.cornerRadius = 15
        followButton.layer.borderWidth = 1
        
        editProfileButton.layer.cornerRadius = 15
        
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.borderWidth = 1
        
        stack(
            profileImageView,
            followButton.withSize(.init(width: 100, height: 28)),
            editProfileButton.withSize(.init(width: 100, height: 28)),
            hstack(stack(postsCountLabel, postsLabel),
                   stack(followersCountLabel, followersLabel),
                   stack(followingCountLabel, followingLabel),
                   spacing: 16, alignment: .center),
            fullNameLabel,
            bioLabel,
            spacing: 12,
            alignment: .center
        ).withMargins(.allSides(14))
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 0.5))
    }
    
    let separatorView = UIView(backgroundColor: .init(white: 0.4, alpha: 0.3))
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
