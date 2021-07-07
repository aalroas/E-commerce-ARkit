//
//  ViewController.swift
//  gproject-ios
//
//  Created by Abdulsalam Alroas on 15/05/2021.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var productCol: UICollectionView!
    private var products = [0: "AR 3D model chair 1",
                                              1: "AR 3D model chair 2",
                                              2: "AR 3D model chair 3",
                                              3: "AR 3D model chair 4"]
    private var products_images = [ "1","2","3","4"]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product_cell", for: indexPath) as! ProductCell
        cell.productImageView.image = UIImage(named:products_images[indexPath.row])
        cell.productNameLabel.text =  products[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productCol.dataSource = self
        self.productCol.delegate = self
        // Do any additional setup after loading the view.
    }


}

