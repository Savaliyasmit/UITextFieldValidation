//
//  textFieldVC.swift
//  iosLearn
//
//  Created by smit on 25/12/24.
//


import UIKit
import Toast_Swift
import IQKeyboardManagerSwift

class textFieldVC:UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var emailValid: UILabel!
    @IBOutlet weak var passValid: UILabel!
    
    var email:String = ""
    var password:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.delegate = self
        passTxt.delegate = self
        emailValid.isHidden = true
        passValid.isHidden = true
        passValid.numberOfLines = 0
       
    }
    
    
    @IBAction func onBtnSubmit(_ sender: UIButton) {
        if email == "user42212@gmail.com" && password == "User@111"{
            guard  let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "textFieldeWithUIPicker") as? textFieldeWithUIPicker else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            self.view.makeToast("Unauthorized", duration: 3.0, position: .bottom , title: "creadtional invalid",image: UIImage(named: "side-menu"))
        }
    }
    
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[^\\s]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func validatePassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    func invalidPassword(_ value: String) -> String?
    {
        if value.contains(" ") {
               return "Password cannot contain spaces"
           }
           
           // Check for minimum length
           if value.count < 8 {
               return "Password must be at least 8 characters"
           }
           
           // Check for a digit
           if !containsDigit(value) {
               return "Password must contain at least 1 digit"
           }
           
           // Check for a lowercase character
           if !containsLowerCase(value) {
               return "Password mustvcontain at least 1 lowercase character"
           }
           
           // Check for an uppercase character
           if !containsUpperCase(value) {
               return "Password must contain at least 1 uppercase character"
           }
           
           return nil
    
    }
    
 
    func containsDigit(_ value: String) -> Bool {
        return value.rangeOfCharacter(from: .decimalDigits) != nil
    }

    func containsLowerCase(_ value: String) -> Bool {
        return value.rangeOfCharacter(from: .lowercaseLetters) != nil
    }

    func containsUpperCase(_ value: String) -> Bool {
        return value.rangeOfCharacter(from: .uppercaseLetters) != nil
    }
    
    
    private func showValidationMessage(label: UILabel, message: String) {
        emailTxt.layer.borderColor = UIColor.systemRed.cgColor
        passTxt.layer.borderColor = UIColor.systemRed.cgColor
        
        label.text = message
        label.isHidden = false
        label.alpha = 0
        UIView.animate(withDuration: 0.3) {
            label.alpha = 1
        }
    }
    
    private func hideValidationMessage(label: UILabel) {
        UIView.animate(withDuration: 0.3, animations: {
            label.alpha = 0
        }) { _ in
            label.isHidden = true
            
        }
    }
    
    func showValidationEffectEmail(_ borderWidth:CGFloat ,_ borderColor:CGColor ){
        emailTxt.layer.borderWidth  = borderWidth
        emailTxt.layer.borderColor = borderColor
        
        emailTxt.layer.shadowColor = UIColor.systemRed.cgColor
        emailTxt.layer.shadowOffset = CGSize(width: 0, height: 2)
        emailTxt.layer.shadowOpacity = borderWidth > 0 ? 0.8 : 0
        emailTxt.layer.shadowRadius = 4
    }
    
    func showValidationEffectPassword(_ borderWidth:CGFloat , _ borderColor:CGColor){
        passTxt.layer.borderWidth = borderWidth
        passTxt.layer.borderColor = borderColor
        
        passTxt.layer.shadowColor = UIColor.systemRed.cgColor
        passTxt.layer.shadowOffset = CGSize(width: 0, height: 2)
        passTxt.layer.shadowOpacity = borderWidth > 0 ? 0.8 : 0
        passTxt.layer.shadowRadius = 4
        
    }
    
    private func validateField(_ textField: UITextField) {
        if textField == emailTxt {
            if validateEmail(emailTxt.text ?? "") {
                email = emailTxt.text ?? ""
                showValidationEffectEmail(0, UIColor.white.cgColor)
                hideValidationMessage(label: emailValid)
            } else {
                showValidationEffectEmail(1, UIColor.systemRed.cgColor)
                showValidationMessage(label: emailValid, message: "Invalid email format")
            }
        } else if textField == passTxt {
            if let message = invalidPassword(passTxt.text ?? "") {
                showValidationEffectPassword(1, UIColor.systemRed.cgColor)
                showValidationMessage(label: passValid, message: message)
            } else {
                password = passTxt.text ?? ""
                showValidationEffectPassword(0, UIColor.white.cgColor)
                hideValidationMessage(label: passValid)
            }
        }
    }
    
}

extension textFieldVC:UITextFieldDelegate {
  
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        validateField(textField)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        email = ""
        password = ""
        passTxt.text = ""
        emailTxt.text = ""
        return true
    }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         validateField(textField)
         return true
     }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           // Ensure the text length stays at or below 8 characters
        if textField == passTxt {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return updatedText.count <= 8
        }
        return true
       }
    
}
