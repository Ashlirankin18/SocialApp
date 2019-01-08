//
//  FavoritePost.swift
//  SicialApp
//
//  Created by Ashli Rankin on 1/7/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation
struct Favorite:Codable {
  let data: [FavoritePost]
}
struct FavoritePost:Codable{
 let  like: String
  let publish_date: String
  let story_text: String
  let userImage:String
}
