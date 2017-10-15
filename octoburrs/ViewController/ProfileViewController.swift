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


protocol ProfileFetchable {
  func fetchProfile() -> Observable<User>
}

struct OctoProfileService: ProfileFetchable {
  
  private let config: TokenConfiguration
  
  init(_ token: String) {
    self.config = TokenConfiguration(token)
  }
  
  func fetchProfile() -> Observable<User> {
    return Observable.create { observer -> Disposable in
      Octokit(self.config).me() { response in
        switch response {
        case .success(let user):
          observer.on(.next(user))
          //observer.on(.completed)
        case .failure(let error):
          observer.onError(error)
        }
      }
     return Disposables.create()
    }
  }
}

struct ProfileViewModel {
  

  private let service: ProfileFetchable
  let user = Variable(User(["": "" as AnyObject]))
  private let disposeBag = DisposeBag()
  
  
  init(service: ProfileFetchable) {
    self.service = service
  }
  
  
  func fetchUser() {
    service.fetchProfile().subscribe(onNext: { user in
      self.user.value = user
    }).disposed(by: disposeBag)
  }
}

class ProfileViewController: UIViewController {
  
  private let viewModel: ProfileViewModel
  private let disposeBag = DisposeBag()
  
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
    //get the user object
    viewModel.user.asObservable().skip(1).subscribe(onNext: { user in
      print(user.login)
    }).disposed(by: disposeBag)
  }
}
