//
//  CommentCell.swift
//  ProyectoFinal_IgnacioNevarez
//
//  Created by Ignacio Esau Nevarez on 03/01/21.
//

import LBTATools

class CommentCell: LBTAListCell<Comment> {
    let usernameLabel = UILabel(text: "Usuario", font: .boldSystemFont(ofSize: 15))
    let profileImageView = CircularImageView(width: 44)
    let fromNowLabel = UILabel(text: "Creado hace 5d", textColor: .gray)
    let commentLabel = UILabel(text: "Comentarios", font: .systemFont(ofSize: 14), textColor: .black, numberOfLines: 0)
    
    override var item: Comment! {
        didSet {
            commentLabel.text = item.text
            profileImageView.sd_setImage(with: URL(string: item.user.profileImageUrl ?? ""))
            fromNowLabel.text = item.fromNow
            usernameLabel.text = item.user.fullName
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        stack(hstack(profileImageView,
                     stack(usernameLabel,
                           fromNowLabel,
                           spacing: 2),
                     UIView(),
                     spacing: 12,
                     alignment: .center),
              commentLabel,
              spacing: 12).withMargins(.allSides(16))
        
        addSeparatorView(leftPadding: 0)
    }
}

