//
//  OrderViewController.swift
//  gproject-ios
//
//  Created by Abdulsalam Alroas on 04/07/2021.
//

import UIKit

class OrderViewController:  UIViewController{
   
    @IBOutlet weak var tableView: UITableView!
    private var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.getOrders()
    }
    
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Networking
extension OrderViewController {
    
    private func getOrders() {
        let session = URLSession.shared
                let url = api.my_order
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
                                guard let retrievedDataArray = json["orders"] as? [Any] else {
                                    return
                                }
                                    for retrievedData in retrievedDataArray {
                                        let orderDict = retrievedData as! [String: Any]
                                        let id = orderDict["id"] as! Int
                                        let name = orderDict["name"] as! String
                                        let total = orderDict["total"] as! String
                                        let image = orderDict["image"] as! String
                                        let status = orderDict["status"] as! String
                                        let qty = orderDict["qty"] as! String
              
                                        let orderObj = Order(id: id, image: image, name: name, total: total, qty: qty, status: status)
                                        self.orders.append(orderObj)
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




extension OrderViewController: UITableViewDelegate, UITableViewDataSource { 
    // number of rows in table view
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.orders.count
      }
      
      // create a cell for each table view row
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          // create a new cell if needed or reuse an old one
          let cell = self.tableView.dequeueReusableCell(withIdentifier: "order_cell") as! OrderCell
          
            let targetOrder = orders[indexPath.row]
        
        
                let url = URL(string: "https://graduation.kodatik.com/\(targetOrder.image)" as! String)
                if url != nil {
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            if data != nil {
                                cell.orderImageView.image = UIImage(data:data!)
                            }else{
                                cell.orderImageView.image = UIImage(named: "2")
                            }
                        }
                    }
                }
        cell.orderNameLabel.text = targetOrder.name
        cell.orderPriceLabel.text = targetOrder.total
        cell.statusLabel.text = targetOrder.status
        cell.qtyLabel.text = targetOrder.qty
        
        
            return cell
      }
      
}
