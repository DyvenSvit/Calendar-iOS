//
//  Storyboarded.swift
//  Calendar
//
//  Created by Maksym Gontar on 16.12.2019.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import UIKit
import Foundation

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
        let id = String(describing:self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
