//
//  AllRelatedImages.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/30/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//

import Foundation
struct AllRelatedImages:Codable {
    let allImages: [ImageQualities]
}
struct ImageQualities:Codable {
    let filename:String
}
