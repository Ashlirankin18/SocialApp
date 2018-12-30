//
//  Posts.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/27/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//

import Foundation
struct Posts:Codable {
    let data: [PostInfo]
}
struct PostInfo:Codable{
    let attributes: Attributes
}
struct Attributes:Codable {
    let title:String
    let publish_date: String
    let story_text:String
    
}
