//
//  ProductDetailViewController.swift
//  gproject-ios
//
//  Created by Abdulsalam Alroas on 07/07/2021.
//

import UIKit

class ProductDetailViewController: UIViewController {
    var productsDetail = [ProductDetail]()
    @IBOutlet weak var pagelabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var product_price: UILabel!
    @IBOutlet weak var productBody: UITextView!
    @IBOutlet weak var productLabel: UILabel!
    var getProductId =  Int()
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getProductDetils()
    }
}


// MARK: - Networking
extension ProductDetailViewController {
    
    func getProductDetils() {
        var baseString = "\(api.product_single)\(getProductId)"
        guard let apiURL = URL(string: baseString) else { return }
        var request = URLRequest(url: apiURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print("# error occured - while session: \(error?.localizedDescription)")
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                    return
                }
         
                guard let retrievedDataArray = json["product"] as? [String: Any] else {
                    return
                }
  
                 
                        let id = retrievedDataArray["id"] as! Int
                        let name = retrievedDataArray["name"] as! String
                        let model = retrievedDataArray["model"] as! String
                        let image = retrievedDataArray["image"] as! String
                        let body = retrievedDataArray["body"] as! String
                        let price = retrievedDataArray["price"] as! String
                        
                        let productObj = ProductDetail(id: id, name: name, image: image, model: model, body: body, price: price)
                        self.productsDetail.append(productObj)
                  
                OperationQueue.main.addOperation({
                    self.showDetails()
                })
                
            } catch let err {
                print("# error occured - while json parsing: \(err.localizedDescription)")
            }
            }.resume()
        
    }
        
        
        func showDetails(){
            for detail in productsDetail{
                
                pagelabel.text = detail.name
                productLabel.text = detail.name
                productBody.text = detail.body
                product_price.text  = detail.price
               
                let url = URL(string: "https://graduation.kodatik.com/\(detail.image)" as! String)
                if url != nil {
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            if data != nil {
                                self.productImage.image = UIImage(data:data!)
                            }else{
                                self.productImage.image = UIImage(named: "2")
                            }
                        }
                    }
                }
                
                
             }
        }
    
}

extension ProductDetailViewController {
    @IBAction private func backButtonTouched() {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let arController = storyboard.instantiateViewController(withIdentifier: "arstory")
            if #available(iOS 13.0, *) {
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(arController)
            } else {
                (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(arController)
            }
          }
    }
    
    
    
    
}
