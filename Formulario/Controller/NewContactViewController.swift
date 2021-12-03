//
//  ViewController.swift
//  Formulario
//
//  Created by esme on 03/12/21.
//

import UIKit

class NewContactViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var lastName2TextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    var viewModel: NewContactViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createTable()
        setUpViews()
        photoImageView.makeRounded()
        firstNameTextField.becomeFirstResponder()
        phoneTextField.delegate = self
    }
    
    // MARK: - Connect to database and create table.
    private func createTable() {
        let database = SQLiteDatabase.sharedInstance
        database.createTable()
    }
    
    // MARK: - Setup the views with the values of the selected contact
    private func setUpViews() {
        if let viewModel = viewModel {
            firstNameTextField.text = viewModel.firstName
            lastNameTextField.text = viewModel.lastName
            lastName2TextField.text = viewModel.lastName2
            emailTextField.text = viewModel.email
            phoneTextField.text = viewModel.phoneNumber
            photoImageView.image = viewModel.photo
        }
    }

    // MARK: - Save new contact or update an existing contact
    @IBAction func saveButton(_ sender: Any) {
        
        let id: Int = viewModel == nil ? 0 : viewModel.id!
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let lastName2 = lastName2TextField.text ?? ""
        let email = emailTextField.text ?? ""
        let phoneNumber = phoneTextField.text ?? ""
        let uiImage = photoImageView.image ?? #imageLiteral(resourceName: "defualtContactIPhoto")
        
      
    
        
        guard let photo = uiImage.pngData() else {return}
        
        let contactValues = Contact(
            id: id,
            firstName: firstName,
            lastName: lastName,
            lastName2: lastName2,
            email: email,
            phoneNumber: phoneNumber,
            photo: photo)
        
        if (self.validContact(contact: contactValues)){
            // If viewModel equal to nil a new contact will be created, otherwise an existing contact will be updated.
            if viewModel == nil {
                // Contact created
                createNewContact(contactValues)
            } else {
                // Contact updated
                updateContact(contactValues)
            }
        }
        
     
    }
    
    // MARK: - Create new contact
    private func createNewContact(_ contactValues:Contact) {
        let contactAddedToTable = SQLiteCommands.insertRow(contactValues)
        
        // Phone number is unique to each contact so we check if it already exists
        if contactAddedToTable == true {
            dismiss(animated: true, completion: nil)
        } else {
            showError("Error", message: "Este contacto no se puede actualizar porque este número de teléfono o correo electrónico ya existe en su lista de contactos.")
        }
    }
    
    // MARK: - Update contact
    private func updateContact(_ contactValues: Contact) {
        let contactUpdatedInTable = SQLiteCommands.updateRow(contactValues)
        
        // Phone number is unique to each contact so we check if it already exists
        if contactUpdatedInTable == true {
            if let cellClicked = navigationController {
                cellClicked.popViewController(animated: true)
            }
        } else {
            showError("Error", message: "Este contacto no se puede actualizar porque este número de teléfono o correo electrónico ya existe en su lista de contactos.")
        }
    }
    
    // MARK: - Cancel button
    @IBAction func cancelButton(_ sender: Any) {
        let addButtonClicked = presentingViewController is UINavigationController
        // If the user clicked add button on the previous screen
        if addButtonClicked {
            // Dismisses back to the previous screen with animation
            dismiss(animated: true, completion: nil)
        }
        // If the user clicked on a cell on the previous screen
        else if let cellClicked = navigationController {
            cellClicked.popViewController(animated: true)
        } else {
            print("The ContactScreenTableViewController is not inside a navigation controller")
        }
    }
}

extension NewContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Image tap gesture
    @IBAction func addImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // let the user pick media from his photo library.
        let imagePickerController = UIImagePickerController()
        
        // Allows to picked photos.
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func validContact(contact: Contact) -> Bool{
       
        if(contact.firstName.isEmpty){
            showError("Nombre Vacío", message: "Ingresa un nombre, por favor")
            return false
        }
        if(contact.lastName.isEmpty){
            showError("Apellido Paterno Vacío", message: "Ingresa un Apellido, por favor")
            return false
        }
        if(contact.lastName2.isEmpty){
            showError("Apellido Materno Vacío", message: "Ingresa un Materno, por favor")
            return false
        }
        if(contact.phoneNumber.count != 14){
            showError("Número de teléfono no válido ", message: "Debe tener 10 dígitos")
            return false
        }
        if (!isValidEmail(contact.email)){
            showError("Email no válido ", message: "Ingrese un formato válido por favor.")
            return false
        }
     
        return true
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

extension NewContactViewController: UITextFieldDelegate {
    // MARK: - Phone number validation
    private func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return false}
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "(XXX) XXX-XXXX", phone: newString)
        return false
    }
}
