//
//  UserFriendsViewController.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/31/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//

import UIKit

class UserFriendsViewController: UIViewController {

  @IBOutlet weak var userFriendsTableView: UITableView!
  private var friends = [Users]() {
    didSet{
      DispatchQueue.main.async {
        self.userFriendsTableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getuserFriends()
    userFriendsTableView.dataSource = self
    }
  private func getuserFriends(){
    UsersApiClient.getUserInfo(numberOfResults: 1200) { (error, friends) in
      if let error = error {
        print(error.errorMessage())
      }
      if let friends = friends {
        self.friends = friends
      }
    }
  }
  private func getFriendImage(url:URL,imageView:UIImageView){
    ImageHelper.fetchImage(urlString: url.absoluteString) { (error, image) in
      if let error = error {
        print(error.errorMessage())
      }
      if let image = image {
        imageView.image = image
        DispatchQueue.main.async {
          self.userFriendsTableView.reloadData()
        }
      }
    }
  }

}
extension UserFriendsViewController:UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friends.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let friendName = friends[indexPath.row].name
     let cell = userFriendsTableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath)
    cell.textLabel!.text = "\(friendName.first.capitalized) \(friendName.last.capitalized)"
    getFriendImage(url: friends[indexPath.row].picture.large, imageView: cell.imageView!)
    return cell
  }
  
  
}
