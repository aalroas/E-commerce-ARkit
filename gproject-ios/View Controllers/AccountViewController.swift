//
//  AccountViewController.swift
//  gproject-ios
//
//  Created by Abdulsalam Alroas on 07/07/2021.
//

import UIKit
import SVProgressHUD

class AccountViewController: UIViewController {
    
    @IBOutlet weak var namelabel: UITextField!
    
    
    @IBOutlet weak var emailLabel: UITextField!
    
    
    @IBOutlet weak var passlabel: UITextField!
    
    @IBOutlet weak var passConLabel: UITextField!
    
    
    @IBAction func updateButton(_ sender: Any) {
            SVProgressHUD.show()
            if(emailLabel.text!.isEmpty){
                SVProgressHUD.dismiss()
                Helper.app.showAlert(title: "Hata", message: "email alanı boş", vc: self)
             return
            }
            if(emailLabel.text!.isEmpty){
              SVProgressHUD.dismiss()
              Helper.app.showAlert(title: "Hata", message: "name alanı boş", vc: self)
              return
            }
      
            let session = URLSession.shared
                    let url = "https://graduation.kodatik.com/api/user/update"
                    let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    request.setValue("Bearer \(UserDefaults.standard.accessToken!)", forHTTPHeaderField: "Authorization")
                    var params :[String: Any]?
                    params = ["email" : emailLabel.text!,
                              "password" : passlabel.text!,
                              "name" : namelabel.text!,
                              "password_confirmation" : passConLabel.text!
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
                                    print(json)
                                    
                                        
                                        SVProgressHUD.dismiss()
                                        DispatchQueue.main.async {
                                            let alert = UIAlertController(title: "Success", message: "profile updated", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: { _ in

                                            }))
                                            self.present(alert, animated: true) {
                                            self.presentingViewController?.dismiss(animated: true, completion: nil)
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
        self.namelabel.text =  UserDefaults.standard.username
        self.emailLabel.text =  UserDefaults.standard.userEmail
        // Do any additional setup after loading the view.
    }
    

 
    @IBAction func logoutButtton(_ sender: Any) {
        // cikis yapmak istegini emin misin
        let alert = UIAlertController(title: "Graduation Project", message: "Do  You to log out?",preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Evet",style: UIAlertAction.Style.destructive,handler: {(_: UIAlertAction!) in
        self.logout()
            
        UserDefaults.standard.removeAll()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(withIdentifier: "login")

        if #available(iOS 13.0, *) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        } else {
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
        }
       }))
       self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func logout() {
    
        let session = URLSession.shared
                let url = api.logout
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("Bearer \(UserDefaults.standard.accessToken!)", forHTTPHeaderField: "Authorization")
                do{
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
}

