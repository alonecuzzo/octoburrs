//
//  OctoIssuesService.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/15/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import Foundation
import Octokit
import RxSwift


/// Type that is responsible for providing an Observable<[Issue]>
protocol IssuesFetchable: Tokenable {
  func fetchIssues(_ repoNamed: String) -> Observable<[Issue]>
}


/// Concrete service that gets repositories for a User
struct OctoIssuesService: IssuesFetchable {
  
  //MARK: Property
  private let config: TokenConfiguration
  private let _token: String
  
  var token: String { return _token }
  
  //MARK: Method
  init(_ token: String) {
    self._token = token
    self.config = TokenConfiguration(token)
  }
  
  func fetchIssues(_ repoNamed: String) -> Observable<[Issue]> {
    return Observable.create { observer -> Disposable in
      _ = Octokit(self.config).issues(owner: "alonecuzzo", repository: repoNamed) { response in
        switch response {
        case .success(let issues):
          observer.on(.next(issues))
        case .failure(let error):
          observer.onError(error)
        }
      }
      return Disposables.create()
    }
  }
}
