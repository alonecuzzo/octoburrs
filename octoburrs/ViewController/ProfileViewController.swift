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


//open var avatarURL: String?
//open var name: String?
//open var location: String?
//open var numberOfPublicRepos: Int?



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
    view.backgroundColor = .white
    viewModel.fetchUser()
    
     let profileImageView = UIImageView(frame: .zero)
    
    viewModel.user.asObservable().subscribe(onNext: { [weak self] user in
      guard user.id > 0,
        let strongSelf = self,
        let avatarURL = user.avatarURL else { return }
      
      profileImageView.sd_setImage(with: URL(string: avatarURL), completed: nil)
      
      
    }).disposed(by: disposeBag)
    
    //profile imageview
   
    profileImageView.backgroundColor = .purple
    profileImageView.layer.cornerRadius = 5
    view.addSubview(profileImageView)
    profileImageView.snp.makeConstraints { make in
      make.width.height.equalTo(250)
      make.centerX.equalTo(view)
      make.top.equalTo(80)
    }
    
    
    //add a button that's going to pop the repo vc flow
    let repoButton = UIButton(frame: CGRect(x: 10, y: 410, width: 300, height: 100))
    view.addSubview(repoButton)
    repoButton.addTarget(self, action: #selector(repoButtonTapped), for: .touchUpInside)
    repoButton.backgroundColor = .red
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
