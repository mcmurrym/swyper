// Playground - noun: a place where people can play

import UIKit
import SwiftyJSON
import Hyper
import AlamoFire
import XCPlayground

XCPSetExecutionShouldContinueIndefinitely()

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

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

let jTest = JSON(1)
let jTest2 = JSON(true)
let jTest3 = JSON("hello")
let jTest4 = JSON(["boom"])
let jTest5 = JSON(NSDate())

let rootLink = HyperObject(baseURLString: "http://private-4bbf0-hyperexperimental.apiary-mock.com/", rootPath: "api")
//rootLink["name"]


//root.open { (hyperObject) -> () in
//    println("got it")
//}

//rootLink.open() { (root) -> () in
//    let user = root.link("curretn_user")
//    
//    ui.navbar.user(user)
//    db.save(user)
//    ui.page(root)
//    
//}

//rootLink.open("moment", attributesNeeded: ["id"]) { (current_user) -> () in
//    println(current_user)
//}


//let label = UILabel()
//
//label.bind("moment.name")



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
