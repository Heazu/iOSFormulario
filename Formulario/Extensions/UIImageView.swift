//
//  UIVIewController.swift
//  ContactList
//
//  Created by kike on 21/11/21.
//

import Foundation
import UIKit

import UIKit

extension UIImageView {
    // Round shaped image
    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}


