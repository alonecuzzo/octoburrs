//
//  OctoProfileService.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/15/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import Foundation
import Octokit
import RxSwift


/// Type that is responsible for providing an Observable<User>
protocol ProfileFetchable {
  func fetchProfile() -> Observable<User>
}


/// Concrete imlpementation that is responsible for retrieving User data
struct OctoProfileService: ProfileFetchable {
  
  //MARK: Property
  private let config: TokenConfiguration
  
  
  //MARK: Method
  init(_ token: String) {
    self.config = TokenConfiguration(token)
  }
  
  func fetchProfile() -> Observable<User> {
    return Observable.create { observer -> Disposable in
      Octokit(self.config).me() { response in
        switch response {
        case .success(let user):
          observer.on(.next(user))
          observer.on(.completed)
        case .failure(let error):
          observer.onError(error)
        }
      }
      return Disposables.create()
    }
  }
}
