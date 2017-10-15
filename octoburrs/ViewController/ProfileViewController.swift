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
    view.backgroundColor = .purple
    viewModel.fetchUser()
    viewModel.user.asObservable().subscribe(onNext: { user in
      guard user.id > 0 else { return }
      print(user.login)
    }).disposed(by: disposeBag)
  }
}
