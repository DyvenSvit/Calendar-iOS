//
//  UI+Utils.swift
//  Calendar
//
//  Created by Maksym Gontar on 04.12.2019.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import UIKit

class UIUtils {
    
    static func getBarItemWithImageNamed(_ imgName:String, action:Selector, target:Any?) -> UIBarButtonItem? {
        guard let image = UIImage.init(named: imgName) else {
            return nil
        }
        let button = UIButton.init(type: .custom)
        button.setImage(image, for: .normal)
        button.showsTouchWhenHighlighted = true
        button.frame = CGRect.init(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        button.addTarget(target, action: action, for: .touchUpInside)
        let bi = UIBarButtonItem.init(customView: button)
        return bi
    }
}
