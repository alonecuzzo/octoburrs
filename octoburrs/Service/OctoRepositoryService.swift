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
protocol RepositoryFetchable: Tokenable {
  func fetchRepositories() -> Observable<[Repository]>
}


/// Concrete service that gets repositories for a User
struct OctoRepositoryService: RepositoryFetchable {
  
  //MARK: Property
  private let config: TokenConfiguration
  private let _token: String
  var token: String { return _token }
  
  //MARK: Method
  init(_ token: String) {
    self._token = token
    self.config = TokenConfiguration(token)
  }
  
  func fetchRepositories() -> Observable<[Repository]> {
    return Observable.create { observer -> Disposable in
      _ = Octokit(self.config).repositories() { response in
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
