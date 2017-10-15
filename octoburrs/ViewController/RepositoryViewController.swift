//
//  RepositoryViewController.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/15/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import Foundation
import UIKit
import Octokit
import RxSwift





class RepositoryViewController: UIViewController {
  
  //MARK: Property
  private let tableView = UITableView(frame: .zero)
  private let viewModel: RepositoryViewModel
  private let disposeBag = DisposeBag()
  
  
  //MARK: Method
  required init(viewModel: RepositoryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .orange
    
    viewModel.fetchRepositories()
    
    viewModel.repositories.asObservable().subscribe(onNext: { repositories in
      print(repositories)
    }).disposed(by: disposeBag)
    
    
  }
}
