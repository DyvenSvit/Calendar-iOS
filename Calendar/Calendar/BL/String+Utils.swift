//
//  String+Utils.swift
//  Calendar
//
//  Created by Developer on 2/26/19.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import Foundation

extension String {
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
    
        var htmlToAttributedString: NSAttributedString? {
            guard let data = data(using: .utf8) else { return NSAttributedString() }
            do {
                return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            } catch {
                return NSAttributedString()
            }
        }
    
        var htmlToString: String {
            return htmlToAttributedString?.string ?? ""
        }
}
