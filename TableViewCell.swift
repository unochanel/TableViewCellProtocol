//
//  File.swift
//  vibes-ios
//
//  Created by 宇野凌平 on 2019/03/09.
//  Copyright © 2019 宇野凌平. All rights reserved.
//

import UIKit

class TableViewCell<T: UIViewController>: UITableViewCell, TableViewCellProtocol {
    typealias Content = T
    var content: T {
        return contentViewController!
    }
    
    weak var parentViewController: UIViewController?
    var contentViewController: T?
    
   override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        _willMove(to: newSuperview)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        _didMoveToSuperview()
    }
}

extension TableViewCell {
    static func register(to tableView: UITableView) {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension TableViewCell where T: Instantiatable {
    static func dequeued<V>(from tableView: UITableView, for indexPath: IndexPath, input: T.Input, parentViewController: V) -> TableViewCell where V: UIViewController, V: Instantiatable {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as Any as! TableViewCell
        if cell.contentViewController == nil {
            cell.addViewController(T.make(input) as! T, parentViewController: parentViewController)
            cell.selectionStyle = .none
        }
        return cell
    }
}
