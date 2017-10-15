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
import RxCocoa


class RepositoryViewController: UIViewController {
  
  //MARK: Property
  private let tableView = UITableView(frame: .zero)
  private let viewModel: RepositoryViewModel
  private let disposeBag = DisposeBag()
  private var repositories: Observable<[Repository]> { return viewModel.repositories.asObservable() }
  private let cellIdentifier = "afsdf"
  
  
  //MARK: Method
  required init(viewModel: RepositoryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .orange
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    view.addSubview(tableView)
    
    viewModel.fetchRepositories()
    
    repositories.bind(to: tableView.rx.items) { tv, row, repository in
      let cell = tv.dequeueReusableCell(withIdentifier: self.cellIdentifier)!
      cell.textLabel?.text = repository.fullName
      cell.selectionStyle = .none
      return cell
    }.disposed(by: disposeBag)
  }
}
