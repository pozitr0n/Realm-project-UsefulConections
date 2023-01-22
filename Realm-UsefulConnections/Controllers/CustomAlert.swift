//
//  CustomAlert.swift
//  Realm-UsefulConnections
//
//  Created by Raman Kozar on 09/01/2023.
//

import UIKit

class CustomAlert: UIViewController, UITextFieldDelegate {

    var isNew: Bool = false
    weak var updateAllTheData: UpdateAllTheData?
    private var currentRow: Int? = 0
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet var alertView: UIView!
    
    @IBOutlet weak var connectionTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlert()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func emailChanged(_ sender: UITextField) {
        changeSmileDependingOnData()
    }
    
    @IBAction func emailEndChanged(_ sender: UITextField) {
       
        if !emailIsValid(emailAddressString: emailTextField.text!) && !emailTextField.text!.isEmpty {
            
            showAlertToUser(title: "Incorrect e-mail address",
                            message: "The entered e-mail address is incorrect",
                            buttonTitle: "OK",
                            textField: self.emailTextField)
            
        }
        
    }
    
    @IBAction func descriptionChanged(_ sender: UITextField) {
        changeSmileDependingOnData()
    }
    
    @IBAction func ratingChanged(_ sender: UITextField) {
        changeSmileDependingOnData()
    }
    
    @IBAction func ratingEndChanged(_ sender: UITextField) {
        
        if !ratingIsValid(rating: ratingTextField.text!) && !ratingTextField.text!.isEmpty {
            
            showAlertToUser(title: "Incorrect rating",
                            message: "The entered rating is incorrect. Possible values: from 0 to 10",
                            buttonTitle: "OK",
                            textField: self.ratingTextField)
            
        }
        
    }
    
    @IBAction func actionSaveButton(_ sender: Any) {
        
        if allTheImportantFieldsAreNotEmpty() {
        
            if isNew {
            
                ConnectionsModel().addNewObjectIntoCollection(emailTextField.text!,
                                                              descriptionTextField.text ?? "",
                                                              ratingTextField.text!)
                
            } else {
              
                ConnectionsModel().updateNewObjectIntoCollection(emailTextField.text!,
                                                                 descriptionTextField.text ?? "",
                                                                 ratingTextField.text!,
                                                                 currentRow!)
                
            }
            
            updateAllTheData?.updateAllTheData()
            self.dismiss(animated: true, completion: nil)
            
        } else {
         
            showAlertToUser(title: "Error",
                            message: "Can't add the connection, check all the fields",
                            buttonTitle: "OK",
                            textField: nil)
            
        }
        
    }
    
    @IBAction func actionCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    init() {
        
        super.init(nibName: "CustomAlert", bundle: Bundle(for: CustomAlert.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAlert(currRow: Int?) {
       
        currentRow = currRow
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        windowScenes?.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        
        if currentRow != nil {
            
            let allTheInfo = ConnectionsModel().getObjectsBySelection(currRow: currentRow!)
        
            emailTextField.text = String(allTheInfo.userEmail)
            descriptionTextField.text = String(allTheInfo.userDescription)
            ratingTextField.text = String(allTheInfo.userRating)
            
        }
        
        changeSmileDependingOnData()
    
    }
    
    private func setupAlert() {
        
        changeSmileDependingOnData()
        
        if isNew {
            saveButton.setTitle("Save", for: .normal)
            connectionTitle.text = "Add new connection"
        } else {
            saveButton.setTitle("Update", for: .normal)
            connectionTitle.text = "Update connection"
        }
        
    }
    
    private func allTheImportantFieldsAreNotEmpty() -> Bool {
        
        var fieldsAreNotEmpty: Bool = true
        
        if emailTextField.text!.isEmpty {
            fieldsAreNotEmpty = false
            return fieldsAreNotEmpty
        }
        
        if ratingTextField.text!.isEmpty {
            fieldsAreNotEmpty = false
            return fieldsAreNotEmpty
        }
        
        return fieldsAreNotEmpty
        
    }
    
    private func changeSmileDependingOnData() {
        
        if allTheImportantFieldsAreNotEmpty() {
            statusImageView.image = UIImage(named: "fun.png")
        } else {
            statusImageView.image = UIImage(named: "sad.png")
        }
        
    }
    
    private func emailIsValid(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return returnValue
        
    }
    
    private func ratingIsValid(rating: String) -> Bool {
        
        let ratingInt = Int(rating)
        
        if (ratingInt != nil) {
            if ratingInt! >= 0 && ratingInt! <= 10 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }

    }
    
    private func showAlertToUser(title: String, message: String, buttonTitle: String, textField: UITextField?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if textField == nil {
            alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
        } else {
        
            alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: {_ in
                textField!.text = ""
            }))
            
        }
    
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
