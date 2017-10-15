//
//  RepositoryViewModel.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/15/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import Foundation
import RxSwift
import Octokit


/// ViewModel that backs a view of a User's Repositories
struct RepositoryViewModel {
  
  //MARK: Property
  let repositories = Variable([Repository]())
  
  private let service: RepositoryFetchable
  private let disposeBag = DisposeBag()
  
  
  //MARK: Method
  init(service: RepositoryFetchable) {
    self.service = service
  }
  
  func fetchRepositories() {
    service.fetchRepositories().subscribe(onNext: { repositories in
      self.repositories.value = repositories
    }).disposed(by: disposeBag)
  }
}
