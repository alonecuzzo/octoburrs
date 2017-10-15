//
//  ProfileViewModel.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/15/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import Foundation


/// ViewModel that provides backing data for a Profile driven view
struct ProfileViewModel {
  
  //MARK: Property
  let user = Variable(User(["": "" as AnyObject]))
  
  private let service: ProfileFetchable
  private let disposeBag = DisposeBag()
  
  
  //MARK: Method
  init(service: ProfileFetchable) {
    self.service = service
  }
  
  func fetchUser() {
    service.fetchProfile().subscribe(onNext: { user in
      self.user.value = user
    }).disposed(by: disposeBag)
  }
}
