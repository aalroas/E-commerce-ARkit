//
//  LoginViewController.swift
//  gproject-ios
//
//  Created by Abdulsalam Alroas on 07/07/2021.
//

import UIKit
import Foundation
import SVProgressHUD
import SafariServices

class RegisterViewController: UIViewController,UITextFieldDelegate, SFSafariViewControllerDelegate {
 
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var passConTextField: UITextField!
    
    @IBAction func registerButton(_ sender: Any) {
 
    
        SVProgressHUD.show()
        if(nameTextfield.text!.isEmpty){
            SVProgressHUD.dismiss()
            Helper.app.showAlert(title: "Hata", message: "adı alanı boş", vc: self)
         return
        }
        if(emailTextField.text!.isEmpty){
          SVProgressHUD.dismiss()
          Helper.app.showAlert(title: "Hata", message: "email alanı boş", vc: self)
          return
        }
        if(passwordTextfield.text!.isEmpty){
          SVProgressHUD.dismiss()
          Helper.app.showAlert(title: "Hata", message: "Şifre alanı boş", vc: self)
          return
        }
        if(passConTextField.text!.isEmpty){
          SVProgressHUD.dismiss()
          Helper.app.showAlert(title: "Hata", message: "Şifre tekrar alanı boş", vc: self)
          return
        }
        
        let session = URLSession.shared
                let url = "https://graduation.kodatik.com/api/register"
                let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                var params :[String: Any]?
                params = ["email" : emailTextField.text!,
                          "password" : passwordTextfield.text!,
                          "name" : nameTextfield.text!,
                          "password_confirmation" : passConTextField.text!
                        ]
                do{
                    request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                    let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                        if let response = response {
                            let nsHTTPResponse = response as! HTTPURLResponse
                            let statusCode = nsHTTPResponse.statusCode
                            print ("status code = \(statusCode)")
                        }
                        if let error = error {
                            print ("\(error)")
                        }
                        if let data = data {
                            do{
                                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                                    return
                                }
                                let errorStatus = json["error"] as! Int
                                
                                if errorStatus == 1 {
                                    SVProgressHUD.dismiss()
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: "Hata", message: "email in use", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: { _ in
                                          }))
                                        self.present(alert, animated: true) {
                                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                                        }
                                      }
                                } else {
                                    
                                    SVProgressHUD.dismiss()
                                    
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: "Success", message: "you can login now", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: { _ in
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let loginNavController = storyboard.instantiateViewController(withIdentifier: "login")

                                            if #available(iOS 13.0, *) {
                                                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
                                            } else {
                                                (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
                                            }
                                            
                                        }))
                                        self.present(alert, animated: true) {
                                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                                        }
                                      }
                                    
                            
                                }
                                     
                            }catch _ {
                                print ("OOps not good JSON formatted response")
                            }
                        }
                    })
                    task.resume()
                }catch _ {
                    print ("Oops something happened buddy")
                }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        nameTextfield.delegate = self
        passwordTextfield.delegate = self
        passConTextField.delegate = self
        emailTextField.delegate = self
        makeTextFieldBorderstyle()
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func makeTextFieldBorderstyle(){
    if #available(iOS 13.0, *) {
//        self.passConTextField.borderStyle = .line
//        self.passwordTextfield.borderStyle = .line
//        self.nameTextfield.borderStyle = .line
//        self.emailTextField.borderStyle = .line
      }
    }

    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}


extension RegisterViewController {
       
       
    func initializeHideKeyboard(){
    //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
    target: self,
    action: #selector(dismissMyKeyboard))
    //Add this tap gesture recognizer to the parent view
    view.addGestureRecognizer(tap)
       
    }
      
       
   
       
    @objc func dismissMyKeyboard(){
    //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
    //In short- Dismiss the active keyboard.
    view.endEditing(true)
    }
      
    
    @IBAction func loginButtton(_ sender: Any) {

           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let loginNavController = storyboard.instantiateViewController(withIdentifier: "login")

           if #available(iOS 13.0, *) {
               (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
           } else {
               (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
           }
    }
    
    
    
   }




