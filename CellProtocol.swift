//
//  CellProtocol.swift
//  vibes-ios
//
//  Created by 宇野凌平 on 2019/03/09.
//  Copyright © 2019 宇野凌平. All rights reserved.
//

import UIKit

protocol CellProtocol: AnyObject {
    associatedtype Content: UIViewController
    var contentView: UIView { get }
    var contentViewController: Content? { get set }
    var parentViewController: UIViewController? { get set }
}

extension CellProtocol where Self: UIView  {
    static var reuseIdentifier: String {
        return String(describing: ObjectIdentifier(Content.self).hashValue)
    }
    
    func _willMove(to newSuperview: UIView?) {
        guard let contentViewController = contentViewController else { return }
        if newSuperview == nil {
            contentViewController.willMove(toParent: parentViewController)
        } else {
            parentViewController?.addChild(contentViewController)
        }
    }
    
    func _didMoveToSuperview() {
        guard let contentViewController = contentViewController else { return }
        if superview == nil {
            contentViewController.removeFromParent()
        } else {
            contentViewController.didMove(toParent: parentViewController)
        }
    }
}

protocol TableViewCellProtocol: CellProtocol {}

extension TableViewCellProtocol where Self: UIView {
    func addViewController(_ viewController: Content, parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        self.contentViewController = viewController
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        _willMove(to: superview)
        contentView.addSubview(viewController.view)
        NSLayoutConstraint.activate(
            [
                viewController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                viewController.view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                viewController.view.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor),
                viewController.view.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
                ] + [
                    viewController.view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                    viewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                    ].map { $0.priority = UILayoutPriority.defaultHigh; return $0 }
        )
        _didMoveToSuperview()
    }
}
