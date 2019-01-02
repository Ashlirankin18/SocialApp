//
//  SearchResultsViewController.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/30/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    @IBOutlet weak var searchResultsTableView: UITableView!
   var users = [Users]() 
    override func viewDidLoad() {
        super.viewDidLoad()
      searchResultsTableView.dataSource = self
    }
  @IBAction func dismissButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  private func getUserImage(url:URL,imageView:UIImageView){
    ImageHelper.fetchImage(urlString: url.absoluteString) { (error, image) in
      if let error = error {
        print(error.errorMessage())
      }
      if let image = image {
        imageView.image = image
        DispatchQueue.main.async {
          self.searchResultsTableView.reloadData()
        }
      }
    }
  }
}
extension SearchResultsViewController: UITableViewDataSource{
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let user = users[indexPath.row]
    let cell =  searchResultsTableView.dequeueReusableCell(withIdentifier: "filteredUsers", for: indexPath)
    cell.textLabel?.text = "\(user.name.first.capitalized) \(user.name.last.capitalized)"
    getUserImage(url: user.picture.large, imageView: cell.imageView!)
    cell.detailTextLabel?.text = "\(user.location.city.capitalized) \(user.location.state.capitalized)"
    return cell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
}
