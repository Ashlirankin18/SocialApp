//
//  CommentsViewController.swift
//  SicialApp
//
//  Created by Ashli Rankin on 1/6/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {
  @IBOutlet weak var commentTextField: UITextField!
  @IBOutlet weak var commentTableView: UITableView!
  
  var comment = String()
  private var comments = [Comments]() {
    didSet{
      DispatchQueue.main.async {
         self.commentTableView.reloadData()
      }
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      getComments()
      commentTextField.delegate = self
      commentTableView.dataSource = self
    }
  
  private func setUpAlertControl(title:String,message:String){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  @IBAction func backButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  private func getComments(){
    UsersApiClient.fetchComments { (error, comments) in
      if let error = error {
        print(error.errorMessage())
      }
      if let comments = comments {
        self.comments = comments
        dump(comments)
      }
    }
  }
  }
extension CommentsViewController:UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let comment = commentTextField.text else {fatalError()}
    commentTextField.resignFirstResponder()
    let commentSent = Comments.init(comment: comment, createdBy: "Ashli Rankin")
    do {
      let data =  try JSONEncoder().encode(commentSent)
      UsersApiClient.postComment(data: data) { (error, sucess) in
        if let error = error{
          DispatchQueue.main.async {
            self.setUpAlertControl(title: "Error", message: error.errorMessage())
          }
        }
        else if sucess {
          DispatchQueue.main.async{
            self.setUpAlertControl(title: "Sucess", message: "Sucessfully Commented")
          }
        }
        else {
          DispatchQueue.main.async {
            self.setUpAlertControl(title: "No Go", message: "Comment not inputed")
          }
        }
      }
    } catch {
      print("Encoding Error: \(error)")
    }
    return true
  }
}
extension CommentsViewController:UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = commentTableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
    cell.textLabel!.text = comments[indexPath.row].comment
    cell.detailTextLabel!.text = comments[indexPath.row].createdBy
    return cell
  }
  
  
}


 
