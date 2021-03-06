//
//  ContactScreenViewModel.swift
//  Formulario
//
//  Created by esme on 03/12/21.
//

import Foundation

class ContactScreenViewModel {
    
    private var contactArray = [Contact]()
    
    func connectToDatabase() {
        _ = SQLiteDatabase.sharedInstance
    }
    
    func loadDataFromSQLiteDatabase() {
        contactArray = SQLiteCommands.presentRows() ?? []
    }
    
    func numberOfRowsInSection (section: Int) -> Int {
        if contactArray.count != 0 {
            return contactArray.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Contact {
        return contactArray[indexPath.row]
    }
}
