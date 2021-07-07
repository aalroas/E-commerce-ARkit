//
//  api.swift
//  gproject-ios
//
//  Created by Abdulsalam Alroas on 07/07/2021.
//

import Foundation

struct api {
    static let base_api = URL(string: "https://graduation.kodatik.com/api/")!
    static let products = URL(string:"\(base_api)products")!
    static let product_single = URL(string:"\(base_api)products/")!
    static let my_order = URL(string:"\(base_api)orders/")!
    static let logout = URL(string:"\(base_api)logout")!
    
}
