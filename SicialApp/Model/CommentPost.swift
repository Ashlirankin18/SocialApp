//
//  CommentPost.swift
//  SicialApp
//
//  Created by Ashli Rankin on 1/6/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation
struct Comment:Codable {
  let encodedData: [Comments]
 
}
struct Comments:Codable{
  let comment:String
  let createdBy:String
}
