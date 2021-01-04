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
        case .evening, .afterevening, .morning, .hours:
            return "t"
        case .liturgy:
            return "b"
        }
    }
    
    func getTextURLPostfixFor(type:Text) -> String {
        switch type {
        case .evening:
            return "v"
        case .afterevening:
            return "n"
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
                                               WebAPI.shared.getText(type: .afterevening, for: day),
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
        let isGregorian = AppSettings.boolValue(.calendarGregorian)
        let calType = isGregorian ? "n" : ""
        let urlString = baseUrl+"/\(year)\(calType)/\(String(format: "%02d", month))/\(prefix)\(String(format: "%02d", dayn))\(postfix).html"
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
        
        let isGregorian = AppSettings.boolValue(.calendarGregorian)
        let calType = isGregorian ? "n" : ""
        if let url = URL(string: baseUrl+"/\(year)\(calType)/\(String(format: "%02d", month))/c.txt") {
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
                    var textProper = text
                    if type == .holiday {
                        textProper = self.fixImagesURL(text: textProper)
                    }
                    
                    CoreStoreStack.stack.perform(
                        asynchronous: { (transaction) -> Void in
                            // using the same variable name protects us from misusing the non-transaction instance
                            let day = transaction.edit(day)!
                            day.fillText(type: type, text: textProper)
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
    
    
    func fixImagesURL(text:String) -> String {
        var result = text.replacingOccurrences(of: "../icons/2020", with: "https://calendar.dyvensvit.org/icons/2020")
        return result.replacingOccurrences(of: "../icons/2021", with: "https://calendar.dyvensvit.org/icons/2021")
    }
    
    let baseIconsUrl = "https://calendar.dyvensvit.org/icons"
    
    func getImagesFromText(text:String) {
        let imageFilenames = matches(for: ".*<img src=\"\\.\\.\\/icons\\/2020\\/(?:.*)\".*", in: text)
        for imageFilename in imageFilenames {
            getImage(filename:imageFilename, for: 2020) {
                success, error in
                if success {
                    print("Success")
                }
                else {
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range(at: 0) )}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func getImage(filename:String, for year:Int, completion:  @escaping (Bool, Error?) -> Void) {
        let urlString = baseIconsUrl+"/\(year)/\(filename)"
        if let url = URL(string: urlString) {
            runDataTaskImage(year:year, url: url, completion: completion)
        }
        else {
            completion(false, CalendarError.unsupportedURL)
        }
    }
    
    @discardableResult
    func runDataTaskImage(year:Int, url:URL, completion: @escaping (Bool, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = defaultSession.dataTask(with: url) { data, response, error in
            // 4
            if let error = error {
                completion(false, error)
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                do {
                    let fileName = url.lastPathComponent
                    if let url = self.saveImageToDocuments(year: year, data: data, fileName: fileName) {
                        completion(true, nil)
                    }
                    else {
                        completion(false, CalendarError.invalidResponse)
                    }
                    
                } catch {
                    completion(false, error)
                }
            }else {
                completion(false, CalendarError.invalidResponse)
            }
        }
        // 7
        dataTask.resume()
        return dataTask
    }
    
    func saveImageToDocuments(year:Int, data:Data, fileName:String) -> URL? {
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // create the destination file url to save your image
        var fileURL = documentsDirectory.appendingPathComponent("icons")
        fileURL = fileURL.appendingPathComponent("2020")
        fileURL = fileURL.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let image = UIImage(data: data), let data = image.jpegData(compressionQuality:  1.0),
          !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                return fileURL
                print("file saved")
            } catch {
                print("error saving file:", error)
                return nil
            }
        }
        else {
            return nil
        }
    }
}
