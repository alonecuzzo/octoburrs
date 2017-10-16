//
//  IssueTableViewCell.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/16/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


enum IssueState {
  case open, closed
}


class IssueTableViewCell: UITableViewCell {
  
  //MARK: Property
  private let openedLabel = UILabel(frame: .zero)
  private let closedLabel = UILabel(frame: .zero)
  var state = IssueState.open {
    didSet {
      switch state {
      case .open:
        openedLabel.isHidden = false
        closedLabel.isHidden = true
      case .closed:
        closedLabel.isHidden = false
        openedLabel.isHidden = true
      }
      setNeedsDisplay()
    }
  }
  
  
  //MARK: Method
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    contentView.addSubview(openedLabel)
    contentView.addSubview(closedLabel)
    
    openedLabel.text = "OPEN"
    closedLabel.text = "CLOSED"
    
    openedLabel.textColor = .green
    closedLabel.textColor = .red
    
    openedLabel.snp.makeConstraints { make in
      make.right.equalTo(contentView.snp.right).inset(20)
      make.centerY.equalTo(contentView)
    }
    
    closedLabel.snp.makeConstraints { make in
      make.right.equalTo(contentView.snp.right).inset(20)
      make.centerY.equalTo(contentView)
    }
    
    openedLabel.isHidden = true
    closedLabel.isHidden = true
  }
}
