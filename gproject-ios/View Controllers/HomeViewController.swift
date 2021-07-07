//
//  HomeViewController.swift
//  gproject-ios
//
//  Created by Abdulsalam Alroas on 04/07/2021.
//
import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var colView: UICollectionView!
     private var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colView.delegate = self
        colView.dataSource = self
        self.getProducts()
    }
    
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.colView.reloadData()
        }
    }
}

// MARK: - Networking
extension HomeViewController {
    
    private func getProducts() {
        let session = URLSession.shared
                let url = api.products
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
                                guard let retrievedDataArray = json["products"] as? [Any] else {
                                    return
                                }
                                    for retrievedData in retrievedDataArray {
                                        let productDict = retrievedData as! [String: Any]
                                        let id = productDict["id"] as! Int
                                        let name = productDict["name"] as! String
                                          let image = productDict["image"] as! String
                    
                                        let productObj = Product(id: id, image: image,name: name)
                                        self.products.append(productObj)
                                    }
                                    self.updateUI()
                                
 
                             
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




extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.products.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product_cell", for: indexPath) as! ProductCell
    let targetProduct = products[indexPath.row]

    
        let url = URL(string: "https://graduation.kodatik.com/\(targetProduct.image)" as! String)
        if url != nil {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    if data != nil {
                        cell.productImageView.image = UIImage(data:data!)
                    }else{
                        cell.productImageView.image = UIImage(named: "2")
                    }
                }
            }
        }
    
    cell.productNameLabel.text = targetProduct.name

    return cell
}
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProductId = products[indexPath.row].id
        
        let des = Destination().detail
        des.getProductId = selectedProductId
        self.present(des, animated: true)

    }
    
    
}
