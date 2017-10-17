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
  private let cellIdentifier = "RepositoryViewController.cellIdentifier"
  
  
  //MARK: Method
  required init(viewModel: RepositoryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    navigationItem.title = "Repositories"
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
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    view.addSubview(tableView)
    
    viewModel.fetchRepositories()
    
    repositories.bind(to: tableView.rx.items) { tv, row, repository in
      let cell = tv.dequeueReusableCell(withIdentifier: self.cellIdentifier)!
      cell.textLabel?.text = repository.name
      cell.selectionStyle = .none
      return cell
    }.disposed(by: disposeBag)
    
    tableView.rx.modelSelected(Repository.self).subscribe(onNext: { [weak self] repository in
      guard let strongSelf = self else { return }
      guard let repoName = repository.name else { return }
      let service = OctoIssuesService(strongSelf.viewModel.token)
      let vm = IssuesViewModel(service: service)
      let ivc = IssuesViewController(viewModel: vm, repoName: repoName)
      strongSelf.navigationController?.pushViewController(ivc, animated: true)
    }).disposed(by: disposeBag)
  }
}
