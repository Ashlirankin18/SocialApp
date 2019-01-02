//
//  UserModel.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/27/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//

import Foundation
struct AllUsers:Codable {
    let results: [User]
}
struct User:Codable {
    let gender: String
    let name: Name
    let email: String
    let picture: Picture
    let location:Location
}
struct Name:Codable {
    let first: String
    let last: String
}
struct Picture:Codable {
    let large: URL
    let thumbnail: URL
}
struct Location:Codable {
    let street: String
    let city:String
    let state:String
}
