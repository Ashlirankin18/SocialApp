//
//  AppTabBarf.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/29/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//

import UIKit
var universalUsers = [Users]()
var universalUser = universalUsers[0]
class AppTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
    }
   
    func getUsers(){
        UsersApiClient.getUserInfo(numberOfResults: 20) { (error, users) in
            if let error = error {
                print(error.errorMessage())
            }
            if let  users = users {
                DispatchQueue.main.async {
                    universalUsers = users
                }
            }
        }
    }
}
