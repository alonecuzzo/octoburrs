//
//  OctoIssueService.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/16/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import Foundation
import RxSwift
import Octokit


struct OctoIssueService {
  
  //MARK: Property
  private let config: TokenConfiguration
  var token: String { return config.accessToken ?? "" }
  
  
  //MARK: Method
  init(_ token: String) {
    self.config = TokenConfiguration(token)
  }
  
  func createIssueFor(_ repoNamed: String, title: String, body: String) -> Observable<Issue> {
    return Observable.create { observer -> Disposable in
      _ = Octokit(self.config).postIssue(owner: "alonecuzzo", repository: repoNamed, title: title, body: body, assignee: "alonecuzzo") { response in
        switch response {
        case .success(let issue):
          observer.on(.next(issue))
        case .failure(let error):
          observer.onError(error)
        }
      }
      return Disposables.create()
    }
  }
  
  func updateIssue(_ repoNamed: String, title: String, body: String, issueNumber: Int) -> Observable<Issue> {
    return Observable.create { observer -> Disposable in
      _ = Octokit(self.config).patchIssue(owner: "alonecuzzo", repository: repoNamed, number: issueNumber, title: title, body: body, assignee: "alonecuzzo", state: .Open) { response in
        switch response {
        case .success(let issue):
          observer.on(.next(issue))
        case .failure(let error):
          observer.onError(error)
        }
      }
      return Disposables.create()
    }
  }
}
