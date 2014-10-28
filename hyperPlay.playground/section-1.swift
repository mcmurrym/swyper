// Playground - noun: a place where people can play

import UIKit
import SwiftyJSON
import Hyper
import AlamoFire
import XCPlayground

XCPSetExecutionShouldContinueIndefinitely()

let path = NSBundle.mainBundle().pathForResource("moments-order", ofType: "json")
let jsonData = NSData(contentsOfFile: path!)


if let data = jsonData {

    let j = HyperObject(JSON(data: data))
    j.open()

    if let action = j.action("cancel") {
        action["fake"] = "bogus"
        action["thingy"] = "first"
        action["reason"] = "thing"
        action.submit()
    }

} else {
    println(jsonData)
}

Alamofire.request(.GET, "http://www.welbe.com").response { (request, response, data, error) -> Void in
    let this = "hello"
}

//let result: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: nil)

//extension JSON {
//    
//    func open() -> JSON {
//        if let href = self["href"].string {
//            return self
//        } else {
//            return JSON.nullJSON
//        }
//    }
//    
//    func action(name: String) -> JSON {
//        if let action = self[name].dictionary {
//            return self[name]
//        } else {
//            return JSON.nullJSON
//        }
//    }
//    
//    func set(name: String, value: String) {
//        if let input = self["input"][name].dictionary {
//            if input["type"]?.string != "hidden" {
//                println("Setting \(name) to \(value) somehow...")
//            }
//        }
//    }
//    
//    
//    
//}
