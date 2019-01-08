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
  var user: User?
  var isPostLiked = false
  private var posts = [PostInfo]() {
    didSet {
      DispatchQueue.main.async {
        self.profileCollectionView.reloadData()
      }
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    profileCollectionView.dataSource = self
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    setUserUi()
  }
  func setLike(button:UIButton){
    if !isPostLiked {
      button.setImage(#imageLiteral(resourceName: "icons8-heart-outline-filled-25.png"), for: .normal)
      guard let like = button.currentTitle?.components(separatedBy: " " ) else {return}
      if let likeUnwrapped = like.first {
        guard let likeInt = Int(likeUnwrapped) else {return}
        let increasedLike = likeInt + 1
        button.setTitle("\(increasedLike) Likes", for: .normal)
        isPostLiked = true
      }
    } else {
      button.setImage(#imageLiteral(resourceName: "icons8-heart-outline-25.png"), for: .normal)
      guard let like = button.currentTitle?.components(separatedBy: " " ) else {return}
      if let likeUnwrapped = like.first {
        guard let likeInt = Int(likeUnwrapped) else {return}
        let decreasedLike = likeInt - 1
        button.setTitle("\(decreasedLike) Likes", for: .normal)
        isPostLiked = false
      }
    }
  }

  @IBAction func likeButton(_ sender: UIButton) {
    setLike(button: sender)
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
    
    guard let user = UserSession.getUser() else { return }
    
    userName.text = "\(user.name.first.capitalized) \(user.name.last.capitalized)"
    userGender.text = "\(user.gender.capitalized)"
    userLocation.text = "\(user.location.city.capitalized) \(user.location.state.capitalized) \(user.location.street.capitalized)"
    self.name = "\(user.name.first.capitalized) \(user.name.last.capitalized)"
    getImage()
    getRandomImage()
    getPost()
  }
  
  private func getImage(){
    guard let user = UserSession.getUser() else { return }
    ImageHelper.shared.fetchImage(urlString: "\(user.picture.large)") { (error, image) in
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
    ImageHelper.shared.fetchImage(urlString: urlString) { (error, image) in
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
  private func convertTheDate(timeInterval:Double) -> String{
    let timeInterval = timeInterval
    let date = Date(timeIntervalSince1970: timeInterval)
    let dateFormater = DateFormatter()
    dateFormater.timeZone = TimeZone(abbreviation: "GMT")
    dateFormater.locale = NSLocale.current
    dateFormater.dateFormat = "yyyy-MM-dd HH:mm"
    let strDate = dateFormater.string(from: date)
    return strDate
  }
}
extension ProfileViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let numberOfLikes = makeList(posts.count)
    let post = posts[indexPath.row].attributes
    guard let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? ProfileCollectionViewCell else {fatalError("No cell found")}
    cell.userPost.text = post.story_text
    cell.profileImage.image = profileImage
    cell.userName.text = name
    cell.likeButton.setTitle("\(numberOfLikes[indexPath.row]) Likes", for: .normal)
    cell.comment.setTitle("Comments", for: .normal)
    cell.publishedDate.text = convertTheDate(timeInterval: Double(post.publish_date)!)
    return cell
  }
}
