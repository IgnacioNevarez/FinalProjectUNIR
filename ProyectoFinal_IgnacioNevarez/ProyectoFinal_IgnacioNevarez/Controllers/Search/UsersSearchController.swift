//
//  UsersSearchController.swift
//  ProyectoFinal_IgnacioNevarez
//
//  Created by Ignacio Esau Nevarez on 03/01/21.
//

import LBTATools

class UsersSearchController: LBTAListController<UserSearchCell, User> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Búsqueda"
        
        Service.shared.searchForUsers { (res) in
            switch res {
            case .failure(let err):
                print("Failed to find users:", err)
            case .success(let users):
                self.items = users
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = items[indexPath.item]
        let controller = ProfileController(userId: user.id)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension UsersSearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
