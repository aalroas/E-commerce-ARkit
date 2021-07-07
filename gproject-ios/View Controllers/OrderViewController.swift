//
//  OrderViewController.swift
//  gproject-ios
//
//  Created by Abdulsalam Alroas on 04/07/2021.
//

import UIKit

class OrderViewController:  UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var orderTableView: UITableView!
    private var products = [ 0: "AR 3D model chair 2" ]
    private var products_images = ["2"]
    private var products_price = [0:"$32"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order_cell") as! OrderCell
        cell.orderImageView.image =  UIImage(named:products_images[indexPath.row])
        cell.orderPriceLabel.text = products_price[indexPath.row]
        cell.orderNameLabel.text =  products[indexPath.row]
        return cell
    }
    


    
  
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderTableView.dataSource = self
        self.orderTableView.delegate = self
        // Do any additional setup after loading the view.
    }
}
