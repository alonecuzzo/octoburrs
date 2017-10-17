//
//  IssuesViewController.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/15/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import UIKit
import Octokit
import RxSwift
import RxCocoa



class IssuesViewController: UIViewController {
  
  //MARK: Property
  private let tableView = UITableView(frame: .zero)
  private let viewModel: IssuesViewModel
  private let disposeBag = DisposeBag()
  private var issues: Observable<[Issue]> { return viewModel.issues.asObservable() }
  private let cellIdentifier = "IssuesViewController.cellIdentifier"
  private let repoName: String
  
  
  //MARK: Method
  required init(viewModel: IssuesViewModel, repoName: String) {
    self.viewModel = viewModel
    self.repoName = repoName
    super.init(nibName: nil, bundle: nil)
    navigationItem.title = "Issues"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.fetchIssues(repoName)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .orange
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addButtonTapped))
    
    tableView.register(IssueTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    view.addSubview(tableView)
    
    issues.bind(to: tableView.rx.items) { tv, row, issue in
      let cell = tv.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! IssueTableViewCell
      cell.textLabel?.text = issue.title
      cell.selectionStyle = .none
      
      guard let issueState = issue.state else { cell.state = .open; return cell }
      
      switch issueState {
      case .Closed:
        cell.state = .closed
      case .Open, .All:
        cell.state = .open
      }
      
      return cell
      }.disposed(by: disposeBag)
    
    tableView.rx.modelSelected(Issue.self).subscribe(onNext: { issue in

    }).disposed(by: disposeBag)
  }
  
  @objc func addButtonTapped(sender: Any?) {
    let service = CreateIssueService(viewModel.token)
    let vm = CreateIssueViewModel(service: service)
    let vc = CreateIssueViewController(viewModel: vm, repoName: repoName, issueMode: .edit, issue: nil)
    navigationController?.pushViewController(vc, animated: true)
  }
}
