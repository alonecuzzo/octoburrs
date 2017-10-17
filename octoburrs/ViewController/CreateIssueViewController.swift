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
  case edit, view, new
  
  var title: String {
    switch self {
    case .edit:
      return "Edit Issue"
    case .view:
      return "View Issue"
    case .new:
      return "New Issue"
    }
  }
}


class CreateIssueViewController: UIViewController {
  
  //MARK: Property
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let issueTitleTextField = UITextField(frame: .zero)
  private let issueBodyTextField = UITextField(frame: .zero)
  private let viewModel: IssueViewModel
  private let disposeBag = DisposeBag()
  private let repoName: String
  private let cellIdentifier = "CreateIssueViewController.cellIdentifier"
  private let createIssueButton = UIButton(frame: .zero)
  private let issueMode: Variable<IssueMode>
  private let issue: Issue?
  
  
  //MARK: Method
  init(viewModel: IssueViewModel, repoName: String, issueMode: IssueMode, issue: Issue?) {
    self.viewModel = viewModel
    self.repoName = repoName
    self.issueMode = Variable(issueMode)
    self.issue = issue
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  private func setup() {
    setupModeBindings()
    setupTableView()
    setupCreateIssueButton()
    issueMode.value = issueMode.value //send new event down the pipe
  }
  
  private func setupModeBindings() {
    issueMode.asObservable().subscribe(onNext: { [weak self] mode in
      guard let strongSelf = self else { return }
      strongSelf.navigationItem.title = mode.title
      switch mode {
      case .new, .edit:
        strongSelf.issueTitleTextField.isUserInteractionEnabled = true
        strongSelf.issueBodyTextField.isUserInteractionEnabled = true
        strongSelf.createIssueButton.isHidden = false
        strongSelf.navigationItem.rightBarButtonItem = nil
      case .view:
        strongSelf.createIssueButton.isHidden = true
        strongSelf.setupEditButton()
      }
    }).disposed(by: disposeBag)
  }
  
  private func setupEditButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editTapped))
  }
  
  @objc private func editTapped() {
    issueMode.value = .edit
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
    tableView.rowHeight = 40
    
    _ = viewModel.menuItems.asObservable().bind(to: tableView.rx.items) { [weak self] tv, row, item in
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
    
    switch issueMode.value {
    case .new, .edit:
      issueTitleTextField.isUserInteractionEnabled = true
      issueBodyTextField.isUserInteractionEnabled = true
      setupBindingsFor(issueTitleTextField, withDefaultString: viewModel.menuItems.value.first!)
      setupBindingsFor(issueBodyTextField, withDefaultString: viewModel.menuItems.value[1])
    case .view:
      issueTitleTextField.isUserInteractionEnabled = false
      issueBodyTextField.isUserInteractionEnabled = false
      guard let issue = issue else { return }
      viewModel.menuItems.value = [issue.title ?? "", issue.body ?? ""]
    }
  }
  
  private func setupCreateIssueButton() {
    view.addSubview(createIssueButton)
    createIssueButton.snp.makeConstraints { make in
      make.top.equalTo(200)
      make.height.equalTo(50)
      make.width.equalTo(180)
      make.centerX.equalTo(view)
    }
    createIssueButton.setTitle("Save Issue", for: .normal)
    createIssueButton.backgroundColor = UIColor.darkGray
    createIssueButton.layer.cornerRadius = 5
    createIssueButton.rx.controlEvent(.touchUpInside).asObservable().subscribe(onNext: { [weak self] _ in
      guard let strongSelf = self else { return }
      strongSelf.viewModel.createIssueForRepositoryNamed(strongSelf.repoName, title: strongSelf.issueTitleTextField.text ?? "", body: strongSelf.issueBodyTextField.text ?? "")
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
    cell.selectionStyle = .none
    textField.text = item
    textField.snp.makeConstraints({ make in
      make.top.bottom.equalTo(cell.contentView)
      make.right.left.equalTo(20)
    })
    return cell
  }
}
