//
//  ContactTableViewCell.swift
//  Formulario
//
//  Created by esme on 03/12/21.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

  
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhoneNumberLabel: UILabel!
    @IBOutlet weak var contactPhotoImageView: UIImageView!
    
    // Set up contact values
        func setCellWithValuesOf(_ contact: Contact) {
            contactNameLabel.text = contact.firstName + " " + contact.lastName
            contactPhoneNumberLabel.text = contact.phoneNumber
            
            let image = UIImage(data: contact.photo)
            contactPhotoImageView.image = image
            contactPhotoImageView.makeRounded()
        }
}
