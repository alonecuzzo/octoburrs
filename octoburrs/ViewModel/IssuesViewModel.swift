//
//  IssuesViewModel.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/15/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import Foundation
import Octokit
import RxSwift


/// ViewModel that backs a view of a User's Repositories
struct IssuesViewModel: Tokenable {
  
  //MARK: Property
  let issues = Variable([Issue]())
  var token: String { return service.token }
  
  private let service: IssuesFetchable
  private let disposeBag = DisposeBag()
  
  
  //MARK: Method
  init(service: IssuesFetchable) {
    self.service = service
  }
  
  func fetchIssues(_ repoNamed: String) {
    service.fetchIssues(repoNamed).subscribe(onNext: { issues in
      self.issues.value = issues
    }).disposed(by: disposeBag)
  }
}
