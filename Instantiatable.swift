//
//  Instantiatable.swift
//  vibes-ios
//
//  Created by 宇野凌平 on 2019/03/09.
//  Copyright © 2019 宇野凌平. All rights reserved.
//

import UIKit

protocol Instantiatable {
    associatedtype Input
    
    static func make(_ input: Input) -> UIViewController
}
