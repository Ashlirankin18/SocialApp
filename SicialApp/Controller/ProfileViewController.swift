//
//  ViewController.swift
//  SicialApp
//
//  Created by Ashli Rankin on 12/27/18.
//  Copyright © 2018 Ashli Rankin. All rights reserved.
//

import UIKit
class ProfileViewController: UIViewController {

    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userCoverPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userGender: UILabel!
    @IBOutlet weak var userLocation: UILabel!

  
    var name = String()
    var profileImage = UIImage()
    private var users = universalUsers
    private var posts = [PostInfo]() {
      didSet {
       DispatchQueue.main.async {
      self.profileCollectionView.reloadData()
           }
        }
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserUi()
        profileCollectionView.dataSource = self
     
    }

    private func getPost(){
        UsersApiClient.getUserPost(numberOfResults: 20) { (error, posts) in
            if let error = error {
                print(error.errorMessage())
            }
            if let posts = posts {
                self.posts = posts
                DispatchQueue.main.async {
                    self.profileCollectionView.reloadData()
                }
                
            }
        }
    }

   private func setUserUi(){
        let user = universalUser
    userName.text = "\(user.name.first.capitalized) \(user.name.last.capitalized)"
    userGender.text = "\(user.gender.capitalized)"
    userLocation.text = "\(user.location.city.capitalized) \(user.location.state.capitalized) \(user.location.street.capitalized)"
    self.name = "\(user.name.first.capitalized) \(user.name.last.capitalized)"
    getImage()
    getRandomImage()
    getPost()
    }
    
    private func getImage(){
       let user = universalUsers.first
        ImageHelper.fetchImage(urlString: "\(user!.picture.large)") { (error, image) in
            if let error = error {
                print(error.errorMessage())
            }
            if let image = image {
                self.userProfileImage.image = image
                self.profileImage = image
            }
        }
    }
    private func getRandomImage(){
        let urlString = "https://picsum.photos/400/300/?random"
        ImageHelper.fetchImage(urlString: urlString) { (error, image) in
            if let error = error{
                print(error.errorMessage())
            }
            if let image = image {
                self.userCoverPhoto.image = image
            }
        }
    }
  private func makeList(_ n: Int) -> [Int]{
    return (0..<n).map{_ in Int.random( in: 1...2000) }
  }
}
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let numberOfLikes = makeList(posts.count)
        let numberOfComments = makeList(posts.count)
        let post = posts[indexPath.row].attributes
        guard let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? ProfileCollectionViewCell else {fatalError("No cell found")}
        cell.userPost.text = post.story_text
        cell.profileImage.image = profileImage
        cell.userName.text = name
        cell.likeButton.setTitle("\(numberOfLikes[indexPath.row]) Likes", for: .normal)
        cell.comment.setTitle("\(numberOfComments[indexPath.row]) Comments", for: .normal)
        return cell
    }
    
}
