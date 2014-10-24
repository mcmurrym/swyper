//
//  Hyper.swift
//  Hyper
//
//  Created by Tim Shadel on 10/24/14.
//  Copyright (c) 2014 O. C. Tanner. All rights reserved.
//

import Foundation
import SwiftyJSON

public class HyperNode {
    
    let json: JSON

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

    public func open() -> HyperObject? {
        if let href = self.json["href"].string {
            println("Wish I could download the full object...")
            return self
        } else {
            return nil
        }
    }

    public override func action(name: String) -> HyperAction? {
        return super.action(name)
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

