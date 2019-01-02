//
//  GeneralProfileViewController.swift
//  SicialApp
//
//  Created by Ashli Rankin on 1/1/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class GeneralProfileViewController: UIViewController {
  @IBOutlet weak var generalUserTableView: UITableView!
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var userProfileImage: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var userGender: UILabel!
  @IBOutlet weak var userAddress: UILabel!
  var user: Users?
  
    override func viewDidLoad() {
      super.viewDidLoad()
      setUi()
    }
  private func setUi(){
    userName.text = "\(user!.name.first.capitalized) \(user!.name.last.capitalized)"
    userGender.text = user?.gender.capitalized
    userAddress.text = user?.location.city.capitalized
  }
  @IBAction func backButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
}

