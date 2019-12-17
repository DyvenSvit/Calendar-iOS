//
//  WebAPI.swift
//  Calendar
//
//  Created by Developer on 2/26/19.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import Foundation
import CoreStore
import PromiseKit
import AwaitKit


extension WebAPI {
    func getTextURLPrefixFor(type:Text) -> String {
        switch type {
        case .holiday:
            return "s"
        case .quotes:
            return "p"
        case .rule:
            return "u"
        case .evening, .morning, .hours:
            return "t"
        case .liturgy:
            return "b"
        }
    }
    
    func getTextURLPostfixFor(type:Text) -> String {
        switch type {
        case .evening:
            return "v"
        case .morning:
            return "u"
        case .hours:
            return "c"
        case .liturgy, .quotes, .holiday, .rule:
            return ""
        }
    }
}

class WebAPI {
    static let shared = WebAPI()
    let defaultSession = URLSession(configuration: .default)
    let baseUrl = "https://calendar.dyvensvit.org/assets/"
    
    
    public func getAllData(month:Int, year:Int, progress:  @escaping (Float) -> Void, completion:  @escaping ([Day]?, Error?) -> Void) {
        WebAPI.shared.getDayListFor(month:month, year:year).done {
            days in
            var resultDays = [Day]()
            for (index, day) in days.enumerated() {
                
                let promises:[Promise<Day>] = [WebAPI.shared.getText(type: .holiday, for: day),
                                               WebAPI.shared.getText(type: .quotes, for: day),
                                               WebAPI.shared.getText(type: .rule, for: day),
                                               WebAPI.shared.getText(type: .liturgy, for: day),
                                               WebAPI.shared.getText(type: .evening, for: day),
                                               WebAPI.shared.getText(type: .morning, for: day),
                                               WebAPI.shared.getText(type: .hours, for: day)]
                
                when(resolved: promises).done { (results: [Result<Day>]) in
                    //print(results)
                    guard let result = results.last else {
                        return
                    }
                    
                    if case let .fulfilled(day) = result {
                        resultDays.append(day)
                    }
                    let progressValue = Float(index+1)/Float(days.count)
                    progress(progressValue)
                    if progressValue == 1 {
                        completion(resultDays, nil)
                    }
                    
                }
            }
            }
            .catch {
                error in
                completion(nil, error)
        }
    }
    
    public func getText(type:Text, for day:Day) -> Promise<Day> {
        return Promise { getText(type: type, for: day, completion: $0.resolve) }
    }
    
    
    func getText(type:Text, for day:Day, completion:  @escaping (Day?, Error?) -> Void) {
       // day.date.
        let year = day.date.getYear()
        let month = day.date.getMonth()
        let dayn = day.date.getDay()
        let prefix = getTextURLPrefixFor(type: type)
        let postfix = getTextURLPostfixFor(type: type)
        let urlString = baseUrl+"/\(year)/\(String(format: "%02d", month))/\(prefix)\(String(format: "%02d", dayn))\(postfix).html"
        if let url = URL(string: urlString) {
            runDataTaskText(type:type, for:day, url: url, completion: completion)
        }
        else {
            completion(nil, CalendarError.unsupportedURL)
        }
    }
    
    public func getDayListFor(month:Int, year:Int) -> Promise<[Day]> {
        return Promise { getDayListFor(month: month, year: year, completion: $0.resolve) }
    }
    
    func getDayListFor(month:Int, year:Int, completion:  @escaping ([Day]?, Error?) -> Void) {
        if let url = URL(string: baseUrl+"/\(year)/\(String(format: "%02d", month))/c.txt") {
            runDataTaskDays(month:month, year:year, url: url, completion: completion)
        }
        else {
            completion(nil, CalendarError.unsupportedURL)
        }
    }
    
    
    @discardableResult
    func runDataTaskText(type:Text, for day:Day, url:URL, completion: @escaping (Day?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = defaultSession.dataTask(with: url) { data, response, error in
            // 4
            if let error = error {
                completion(nil, error)
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                do {
                    guard let text = String(bytes: data, encoding: String.Encoding.utf8) else {throw CalendarError.invalidResponse}
                    CoreStoreStack.stack.perform(
                        asynchronous: { (transaction) -> Void in
                            // using the same variable name protects us from misusing the non-transaction instance
                            let day = transaction.edit(day)!
                            day.fillText(type: type, text: text)
                    },
                        completion: { _ in
                            let day = CoreStoreStack.stack.fetchExisting(day)
                            completion(day, nil)
                    }
                    )
                    
                } catch {
                    completion(nil, error)
                }
            }else {
                completion(nil, CalendarError.invalidResponse)
            }
        }
        // 7
        dataTask.resume()
        return dataTask
    }
    
    @discardableResult
    func runDataTaskDays(month:Int, year:Int, url:URL, completion: @escaping ([Day]?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = defaultSession.dataTask(with: url) { data, response, error in
            // 4
            if let error = error {
                completion(nil, error)
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                do {
                    let text = String(bytes: data, encoding: String.Encoding.utf8)
                    guard let lines = text?.lines else {throw CalendarError.invalidResponse}
                    
                    let linesUpdated = lines.map{"\(year)|"+String(format: "%02d", month)+"|"+$0}
                    
                    let source = linesUpdated.map{$0.components(separatedBy: "|")}
                    self.importObjects(into: Into<Day>(), source: source, completion: completion)
                } catch {
                    completion(nil, error)
                }
            }else {
                completion(nil, CalendarError.invalidResponse)
            }
        }
        // 7
        dataTask.resume()
        return dataTask
    }
    
    func importObjects<T:ImportableUniqueObject>(into: Into<T>, source: [T.ImportSource], completion: @escaping ([T]?, Error?) -> Void){
        
        CoreStoreStack.stack.perform(asynchronous: { (transaction) -> [T] in
            let imported = try transaction.importUniqueObjects(into, sourceArray: source)
            return imported
        }, success: { (objects) in
            let fetchedObjects = CoreStoreStack.stack.fetchExisting(objects)
            completion(fetchedObjects, nil)
        }, failure: { failure in
            completion(nil, failure)
        })
    }
}
