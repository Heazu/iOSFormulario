//
//  NewContactViewModel.swift
//  Formulario
//
//  Created by esme on 03/12/21.
//

import UIKit

class NewContactViewModel {
    
    private var contactValues: Contact?
    
    let id: Int?
    let firstName: String?
    let lastName: String?
    let lastName2: String?
    let email: String?
    let phoneNumber: String?
    let photo: UIImage?
    
    init(contactValues: Contact?) {
        self.contactValues = contactValues
        
        self.id = contactValues?.id
        self.firstName = contactValues?.firstName
        self.lastName = contactValues?.lastName
        self.lastName2 = contactValues?.lastName2
        self.email = contactValues?.email
        self.phoneNumber = contactValues?.phoneNumber
        self.photo = UIImage(data: contactValues!.photo)
        
    }
}
