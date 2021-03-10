//
//  UserTableViewCell.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 10.03.21.
//

import UIKit
import AlamofireImage

class UserTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var userImageView: UIImageView!
    @IBOutlet fileprivate weak var userNameLabel: UILabel!
    @IBOutlet fileprivate weak var userAdditinalInfoLabel: UILabel!
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.layer.cornerRadius = 6
        self.userImageView.clipsToBounds = true
    }
    
    func update(_ user: User) {
        if let url = user.pictureUrlString.url {
            self.userImageView.af.setImage(withURL: url)
        }
    }
    
}
