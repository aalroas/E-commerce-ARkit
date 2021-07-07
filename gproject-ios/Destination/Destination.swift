//
//  Destination.swift
//  gproject-ios
//
//  Created by Abdulsalam Alroas on 07/07/2021.
//

import Foundation
import UIKit
struct _Storyboard {
    static let main = UIStoryboard.init(name: "Main", bundle: nil)
}

struct Destination {
    let detail = _Storyboard.main.instantiateViewController(withIdentifier: "product") as! ProductDetailViewController
}
