//
//  IssueViewModel.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/16/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import Foundation
import Octokit
import RxSwift


struct IssueViewModel {
  
  //MARK: Property
  let menuItems = Variable(["Enter Issue Title", "Enter Issue Body"])
  let createdIssue: Variable<Issue?> = Variable(nil)
  private let service: OctoIssueService
  private let disposeBag = DisposeBag()
  
  
  //MARK: Method
  init(service: OctoIssueService) {
    self.service = service
  }
  
  func createIssueForRepositoryNamed(_ repoName: String, title: String, body: String) {
    service.createIssueFor(repoName, title: title, body: body).subscribe(onNext: { issue in
      self.createdIssue.value = issue
    }).disposed(by: disposeBag)
  }
  
//  Octokit(config).patchIssue("owner", repository: "repo", number: 1347, title: "Found a bug", body: "I'm having a problem with this.", assignee: "octocat", state: .Closed) { response in
//  switch response {
//  case .success(let issue):
//  // do something with the issue
//  case .failure:
//  // handle any errors
//  }
//  }
  
  func updateIssueForRepositoryNamed(_ repoName: String, title: String, body: String, issueNumber: Int) {
    
  }
  
}
