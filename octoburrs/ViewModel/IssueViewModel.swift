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
  let issue: Variable<Issue?> = Variable(nil)
  private let service: OctoIssueService
  private let disposeBag = DisposeBag()
  
  
  //MARK: Method
  init(service: OctoIssueService) {
    self.service = service
  }
  
  func createIssueForRepositoryNamed(_ repoName: String, title: String, body: String) {
    service.createIssueFor(repoName, title: title, body: body).subscribe(onNext: { issue in
      self.issue.value = issue
    }).disposed(by: disposeBag)
  }

  
  func updateIssueForRepositoryNamed(_ repoName: String, title: String, body: String, issueNumber: Int) {
    service.updateIssue(repoName, title: title, body: body, issueNumber: issueNumber).subscribe(onNext: { issue in
      self.issue.value = issue
    }).disposed(by: disposeBag)
  }
  
}
