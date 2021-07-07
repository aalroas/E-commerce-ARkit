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

class LoginViewController: UIViewController,UITextFieldDelegate, SFSafariViewControllerDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
 
    
        SVProgressHUD.show()
        if(usernameTextField.text!.isEmpty){
            SVProgressHUD.dismiss()
            Helper.app.showAlert(title: "Hata", message: "kullanıcı adı alanı boş", vc: self)
         return
        }
        if(passwordTextField.text!.isEmpty){
          SVProgressHUD.dismiss()
          Helper.app.showAlert(title: "Hata", message: "Şifre alanı boş", vc: self)
          return
        }
        
        let session = URLSession.shared
                let url = "https://graduation.kodatik.com/api/login"
                let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                var params :[String: Any]?
                params = ["email" : usernameTextField.text!, "password" : passwordTextField.text!]
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
                                print(json)
    
                                
                                let errorStatus = json["error"] as! Int
                                
                                if errorStatus == 1 {
                                    SVProgressHUD.dismiss()
                                    
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: "Hata", message: "kullanıcı adı veya şifre yanlış", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: { _ in
                                          }))
                                        self.present(alert, animated: true) {
                                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                                        }
                                      }
                                } else {
                                    
                                    let access_token =   json["access_token"] as! String
                                    let user =   json["user"] as!  [String: Any]
                                  
                                    UserDefaults.standard.accessToken = access_token
                                    UserDefaults.standard.username = user["name"] as! String
                                    UserDefaults.standard.userEmail = user["email"] as! String
            
                                    SVProgressHUD.dismiss()
                                    
                                    DispatchQueue.main.async {
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let homeController = storyboard.instantiateViewController(withIdentifier: "home")
                                        if #available(iOS 13.0, *) {
                                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeController)
                                        } else {
                                            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(homeController)
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
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        makeTextFieldBorderstyle()
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func makeTextFieldBorderstyle(){
//    if #available(iOS 13.0, *) {
//        self.usernameTextField.borderStyle = .line
//        self.passwordTextField.borderStyle = .line
//      }
    }

    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}


extension LoginViewController {
       
       
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
    
    @IBAction func registerButtton(_ sender: Any) {

           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let loginNavController = storyboard.instantiateViewController(withIdentifier: "register")

           if #available(iOS 13.0, *) {
               (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
           } else {
               (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
           }
    }
    
       
    
   }




