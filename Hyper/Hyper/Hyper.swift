//
//  Hyper.swift
//  Hyper
//
//  Created by Tim Shadel on 10/24/14.
//  Copyright (c) 2014 O. C. Tanner. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class HyperSession {
    private let baseURL: NSURL
    let manager: Manager
    init(_ baseURL: String) {
        self.baseURL = NSURL(string: baseURL)!
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.manager = Alamofire.Manager(configuration: sessionConfig)
    }
    
    func urlFromRelativeURL(string: String) -> String {
        
        if let url = NSURL(string: string, relativeToURL: self.baseURL) {
            if let stringURL = url.absoluteString {
                return stringURL
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}

public class HyperNode {
    
    var json: JSON

    public init(_ json: JSON) {
        self.json = json
    }

    public func action(name: String) -> HyperAction? {
        let actionJSON = self.json[name]
        if let actionHref = actionJSON["action"].string {
            return HyperAction(actionJSON)
        }
        return nil
    }
}


public class HyperObject : HyperNode {

    var session: HyperSession?
    var onCompletionClosures: [(HyperObject?)->()] = []
    var loading: Bool = false
    
    public func open() -> HyperObject {
        return self.open { (hyperObject) -> () in }
    }
    
    public func open(onCompletion:(HyperObject?)->()) -> HyperObject {
        return self.open("", onCompletion: onCompletion)
    }
    
    public func open(keyPath: String, onCompletion:(HyperObject?)->()) -> HyperObject {
        return self.open(keyPath, attributesNeeded: [], onCompletion: onCompletion)
    }
    
    public func open(keyPath: String, attributesNeeded: [String], onCompletion:(HyperObject?)->()) -> HyperObject {
        if countElements(attributesNeeded) > 0 && self.hasAllAttributesReady(attributesNeeded) { //add depth
            onCompletion(self)
        } else {
            self.onCompletionClosures.append(onCompletion)
            if !self.loading {
                self.load({ () -> () in
                    //what's next
                    //self.runLoadFunctions()
                })
            }
        }
        
        return self
    }
    
    func hasAllAttributesReady(attributes: [String]) -> Bool {
        var hasAll = true
        for attribute in attributes {
            let item = self.json[attribute]
            if item == JSON.nullJSON {
                hasAll = false
                break
            }
        }
        
        return hasAll
    }
    
    func load(onCompletion: ()->()) {
        if let href = self.href() {
            self.loading = true
            
            self.session!.manager.request(.GET, href).responseSwiftyJSON { (req, resp, data, error) -> Void in
                if let err = error {
                    println(error)
                } else {
                    self.json = data
                    self.loading = false
                    println(data)
                }
                onCompletion()
            }
        } else {
            println("no href \(self.json)")
        }
    }
    
    func href() -> String? {
        if let aSession = self.session {
            if let href = self.json["href"].string {
                let urlString = aSession.urlFromRelativeURL(href)
                
                return urlString
            }
        }
        
        return nil
    }
    
    func runLoadFunctions () {
        for closure in self.onCompletionClosures {
            println("run load function")
            closure(self)
        }
        
        self.onCompletionClosures = []
    }
    
    public convenience init (baseURLString aBaseURLString: String, rootPath aRootPath: String) {
        
        let session = HyperSession(aBaseURLString)
        let json = JSON(["href" : aRootPath])
        self.init(json)

        self.session = session
    }
    
    func childHyperObject(json: JSON) -> HyperObject {
        let hyper = HyperObject(json)
        hyper.session = self.session
        
        return hyper
    }
    
    public override func action(name: String) -> HyperAction? {
        return super.action(name)
    }
}


extension HyperObject {
    
    public func valueForKeyPath(string: String) -> HyperObject {
        let key = string as NSString
        
//        self.open("path.to.item") { |item|
//            
//        }
//        
//        self.open("path.to.item", ["prop1", "prop2"]) { |item|
//            
//        }
        
//        var returnHyperObject = self
        
        let pathComponents = key.componentsSeparatedByString(".")
        var componentIndex = 0

        var json = self.json
        
        for component in pathComponents as [String] {
            json = json[component]
        }
        
        
        return self.childHyperObject(json)
//        
//            let json = self.json[componentIndex]
//
//            if json == JSON.nullJSON {
//                self.open()?.onLoad({ (hyperObj) -> () in
//                    
////                    if componentIndex < pathCompo
//    
//                    if let hyper = hyperObj {
//                        
//                    }
//                })
//            } else {
//                currentJSON = json
//                hyper = self.childHyperObject(currentJSON)
//            }
////        }
//        
//        return returnHyperObject
    }
}


public class HyperAction : HyperNode {
    
    var values: Dictionary<String, AnyObject>
    var inputs: Dictionary<String, HyperInput>

    override init(_ json: JSON) {
        self.values = Dictionary()
        self.inputs = Dictionary()
        for (name: String, value: JSON) in json["input"] {
            self.inputs[name] = HyperInput(value)
            if let stringValue = value["value"].string {
                self.values[name] = stringValue
            }
        }
        super.init(json)
    }

    public subscript(name: String) -> AnyObject? {
        get {
            return self.values[name]
        }
        set {
            if let input = self.inputs[name] {
                if input.json["type"].string != "hidden" {
                    self.values[name] = newValue
                }
            }
        }
    }

    public func submit() -> HyperObject? {
        let method = self.json["method"]
        let action = self.json["action"]
        println("\(method) \(action) HTTP/1.1")
        for (name: String, value: AnyObject) in self.values {
            println("\(name)=\(value)")
        }
        return nil
    }
}


class HyperInput : HyperNode {

    var value: AnyObject?

}


class HyperTextInput : HyperInput {

}


class HyperDateInput : HyperInput {
    
}

