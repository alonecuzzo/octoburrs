//
//  CreateIssueViewController.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/15/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import Octokit


enum IssueMode {
  case edit, view
}


class CreateIssueViewController: UIViewController {
  
  //MARK: Property
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let issueTitleTextField = UITextField(frame: .zero)
  private let issueBodyTextField = UITextField(frame: .zero)
  private let viewModel: CreateIssueViewModel
  private let repoName: String
  private let disposeBag = DisposeBag()
  private let cellIdentifier = "CreateIssueViewController.cellIdentifier"
  private let createIssueButton = UIButton(frame: .zero)
  private let issueMode: IssueMode
  private let issue: Issue?
  
  
  //MARK: Method
  init(viewModel: CreateIssueViewModel, repoName: String, issueMode: IssueMode, issue: Issue?) {
    self.viewModel = viewModel
    self.repoName = repoName
    self.issueMode = issueMode
    self.issue = issue
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "New Issue"
    setup()
  }
  
  private func setup() {
    setupTableView()
    setupButton()
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
    tableView.rowHeight = 40
    
    viewModel.menuItems.asObservable().bind(to: tableView.rx.items) { [weak self] tv, row, item in
      guard let strongSelf = self else { return UITableViewCell() }
      switch row {
      case 0:
        return CreateIssueCellFactory.makeTableViewCellFor(tableView: tv, item: item, cellIdentifier: strongSelf.cellIdentifier, textField: strongSelf.issueTitleTextField)
      case 1:
        return CreateIssueCellFactory.makeTableViewCellFor(tableView: tv, item: item, cellIdentifier: strongSelf.cellIdentifier, textField: strongSelf.issueBodyTextField)
      default:
        return UITableViewCell()
      }
    }
    
    setupBindingsFor(issueTitleTextField, withDefaultString: viewModel.menuItems.value.first!)
    setupBindingsFor(issueBodyTextField, withDefaultString: viewModel.menuItems.value[1])
    
    switch issueMode {
    case .edit:
      issueTitleTextField.isUserInteractionEnabled = true
      issueBodyTextField.isUserInteractionEnabled = true
    case .view:
      issueTitleTextField.isUserInteractionEnabled = false
      issueBodyTextField.isUserInteractionEnabled = false
    }
  }
  
  private func setupButton() {
    view.addSubview(createIssueButton)
    createIssueButton.snp.makeConstraints { make in
      make.top.equalTo(200)
      make.height.equalTo(50)
      make.width.equalTo(180)
      make.centerX.equalTo(view)
    }
    createIssueButton.setTitle("Save New Issue", for: .normal)
    createIssueButton.backgroundColor = UIColor.darkGray
    createIssueButton.layer.cornerRadius = 5
    createIssueButton.rx.controlEvent(.touchUpInside).asObservable().subscribe(onNext: { [weak self] _ in
      guard let strongSelf = self else { return }
      strongSelf.viewModel.createIssueForRepositoryNamed(strongSelf.repoName, title: strongSelf.issueTitleTextField.text ?? "", body: strongSelf.issueBodyTextField.text ?? "")
       print("tapped with repo name" + strongSelf.repoName)
    }).disposed(by: disposeBag)
    
    viewModel.createdIssue.asObservable().subscribe(onNext: { [weak self] issue in
      guard issue != nil else { return }
      DispatchQueue.main.async {
        self?.navigationController?.popViewController(animated: true)
      }
    }).disposed(by: disposeBag)
  }
  
  private func setupBindingsFor(_ textField: UITextField, withDefaultString defaultString: String) {
  textField.rx.controlEvent(.editingDidBegin).asObservable().subscribe(onNext: { _ in
      if textField.text == defaultString {
        textField.text = ""
      }
    }).disposed(by: disposeBag)
  }
}


//MARK: - Helper
struct CreateIssueCellFactory {
  static func makeTableViewCellFor(tableView: UITableView, item: String, cellIdentifier: String, textField: UITextField) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
    cell.contentView.addSubview(textField)
    textField.text = item
    textField.snp.makeConstraints({ make in
      make.top.bottom.equalTo(cell.contentView)
      make.right.left.equalTo(20)
    })
    return cell
  }
}
