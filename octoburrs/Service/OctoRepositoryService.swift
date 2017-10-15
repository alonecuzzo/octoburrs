//
//  OctoRepositoryService.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/15/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import Foundation
import Octokit
import RxSwift


/// Type that is responsible for providing an Observable<[Repository]>
protocol RepositoryFetchable {
  func fetchRepositories() -> Observable<[Repository]>
}


/// Concrete service that gets repositories for a User
struct OctoRepositoryService: RepositoryFetchable {
  
  //MARK: Property
  private let config: TokenConfiguration
  
  
  //MARK: Method
  init(_ token: String) {
    self.config = TokenConfiguration(token)
  }
  
  func fetchRepositories() -> Observable<[Repository]> {
    return Observable.create { observer -> Disposable in
      Octokit(self.config).repositories() { response in
        switch response {
        case .success(let repositories):
          observer.on(.next(repositories))
          observer.on(.completed)
        case .failure(let error):
          observer.onError(error)
        }
      }
      return Disposables.create()
    }
  }
}
