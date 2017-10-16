//
//  CreateIssueViewModel.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/16/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import Foundation
import Octokit
import RxSwift


struct CreateIssueViewModel {
  
  //MARK: Property
  let menuItems = Variable(["Enter Issue Title", "Enter Issue Body"])
  let createdIssue: Variable<Issue?> = Variable(nil)
  private let service: CreateIssueService
  private let disposeBag = DisposeBag()
  
  
  //MARK: Method
  init(service: CreateIssueService) {
    self.service = service
  }
  
  func createIssueForRepositoryNamed(_ repoName: String, title: String, body: String) {
    service.createIssueFor(repoName, title: title, body: body).subscribe(onNext: { issue in
      self.createdIssue.value = issue
    }).disposed(by: disposeBag)
  }
}
