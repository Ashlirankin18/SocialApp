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
  
  
}
extension SearchResultsViewController: UITableViewDataSource{
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let user = users[indexPath.row]
    let cell =  searchResultsTableView.dequeueReusableCell(withIdentifier: "filteredUsers", for: indexPath)
    cell.textLabel?.text = "\(user.name.first) \(user.name.last)"
    return cell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
}
