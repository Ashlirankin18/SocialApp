//
//  NewsFeedViewController.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/27/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//
import UIKit
class NewsFeedViewController: UIViewController {
    @IBOutlet weak var newsFeedTableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
  private var allUsers = [Users]() {
    didSet{
      DispatchQueue.main.async {
        self.newsFeedTableView.reloadData()
      }
    }
  }
    private var currentAppUser: Users?
  private var posts = [PostInfo]() {
    didSet {
      DispatchQueue.main.async {
        self.newsFeedTableView.reloadData()
      }
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        getPost()
        newsFeedTableView.dataSource = self
    }
  
  private func makeList(_ n: Int) -> [Int]{
    return (0..<n).map{_ in Int.random( in: 1...2000) }
  }
  
private func setImages(url:URL, imageView:UIImageView){
        ImageHelper.fetchImage(urlString: url.absoluteString) { (error, image) in
            if let error = error {
                print(error.errorMessage())
            }
            if let image = image {
                imageView.image = image
              
            }
        }
    }
private func getPost(){
        UsersApiClient.getUserPost(numberOfResults: 20) { (error, posts) in
            if let error = error {
                print(error.errorMessage())
            }
            if let posts = posts {
                self.posts = posts
                self.allUsers = Array(universalUsers[1...universalUsers.count-1])
                self.currentAppUser = universalUser
                self.setsUpUserCredentials()
            }
        }
    }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let indexPath = newsFeedTableView.indexPathForSelectedRow,
      let destination = segue.destination as? GeneralProfileViewController else {fatalError()}
    destination.user = allUsers[indexPath.row]
  }

private func setsUpUserCredentials(){
    self.setImages(url: (currentAppUser?.picture.large)!, imageView: self.userImage)
    DispatchQueue.main.async {
        self.userName.text = "\(self.currentAppUser!.name.first.capitalized) \(self.currentAppUser!.name.last.capitalized)"
    }
    }
}
extension NewsFeedViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let numberOfLikes = makeList(posts.count)
        let numberOfComments = makeList(posts.count)
        guard let cell = newsFeedTableView.dequeueReusableCell(withIdentifier: "newsFeedCell", for: indexPath) as? NewFeedTableViewCell,
            allUsers.count > 0 else { return UITableViewCell()
        }
        let oneUser = allUsers[indexPath.row]
        cell.userName.text = "\(oneUser.name.first.capitalized) \(oneUser.name.last.capitalized)"
        setImages(url: oneUser.picture.thumbnail, imageView: cell.userImage)
        cell.userPost.text = post.attributes.story_text
        cell.likeButton.setTitle("\(numberOfLikes[indexPath.row]) Likes", for: .normal)
        cell.commentButton.setTitle("\(numberOfComments[indexPath.row]) Comments", for: .normal)
        return cell
    }
}
