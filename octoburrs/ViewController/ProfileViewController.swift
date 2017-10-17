//
//  ProfileViewController.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/15/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Octokit
import SnapKit
import SDWebImage


/// ViewController that provides view for a Github user's profile
class ProfileViewController: UIViewController {
  
  //MARK: Property
  private let viewModel: ProfileViewModel
  private let disposeBag = DisposeBag()
  
  
  //MARK: Method
  required init(viewModel: ProfileViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
    setup()
    viewModel.fetchUser()
  }
  
  private func setup() {
    
    //init views
    let profileImageView = UIImageView(frame: .zero)
    let nameLabel = UILabel(frame: .zero)
    let locationLabel = UILabel(frame: .zero)
    let repoButton = UIButton(frame: .zero)
    
    //binding
    viewModel.user.asObservable().subscribe(onNext: { user in
      guard user.id > 0,
        let avatarURL = user.avatarURL else { return }
      profileImageView.sd_setImage(with: URL(string: avatarURL), completed: nil)
      DispatchQueue.main.async {
        nameLabel.text = user.name?.uppercased()
        locationLabel.text = user.location?.uppercased()
        let numRepos = user.numberOfPublicRepos ?? 0
        let repoButtonText = "\(numRepos) Public Repositories"
        repoButton.setTitle(repoButtonText, for: .normal)
      }
    }).disposed(by: disposeBag)
    
    //profile
    profileImageView.layer.cornerRadius = 5
    view.addSubview(profileImageView)
    profileImageView.snp.makeConstraints { make in
      make.width.height.equalTo(250)
      make.centerX.equalTo(view)
      make.top.equalTo(80)
    }
    
    //name
    view.addSubview(nameLabel)
    nameLabel.textAlignment = .center
    nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
    nameLabel.textColor = UIColor.githubLightGray
    nameLabel.snp.makeConstraints { make in
      make.left.right.equalTo(view)
      make.top.equalTo(profileImageView.snp.bottom).offset(10)
    }
    
    //location
    view.addSubview(locationLabel)
    locationLabel.textAlignment = .center
    locationLabel.textColor = UIColor.githubLightGray
    locationLabel.font = UIFont.boldSystemFont(ofSize: 30)
    locationLabel.snp.makeConstraints { make in
      make.left.right.equalTo(view)
      make.top.equalTo(nameLabel.snp.bottom).offset(10)
    }
    
    //repositories button
    view.addSubview(repoButton)
    repoButton.snp.makeConstraints { make in
      make.left.right.equalTo(view).inset(20)
      make.height.equalTo(50)
      make.top.equalTo(locationLabel.snp.bottom).offset(10)
      make.centerX.equalTo(view)
    }
    repoButton.layer.cornerRadius = 5
    repoButton.addTarget(self, action: #selector(repoButtonTapped), for: .touchUpInside)
    repoButton.backgroundColor = UIColor.githubBlue
  }
  
  @objc func repoButtonTapped(sender: Any?) {
    let repoService = OctoRepositoryService(viewModel.token)
    let vm = RepositoryViewModel(service: repoService)
    let rvc = RepositoryViewController(viewModel: vm)
    rvc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissRepoVc))
    let nvc = UINavigationController(rootViewController: rvc)
    present(nvc, animated: true)
  }
  
  @objc func dismissRepoVc(sender: Any?) {
    dismiss(animated: true)
  }
}
