//
//  ViewController.swift
//  LibraryQuoteTest
//
//  Created by zjhaha on 16/1/6.
//  Copyright © 2016年 zjhaha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //获取XML路径
        let xmlPath = NSBundle.mainBundle().pathForResource("testXML", ofType: "xml")
        //获取XML文件内容
        let xmlData = NSData(contentsOfFile: xmlPath!)
        
        //输出
        print(NSString(data: xmlData!, encoding: NSUTF8StringEncoding))
        
        //开始格式化数据
        let doc:GDataXMLDocument! = try? GDataXMLDocument(data: xmlData, encoding: NSUTF8StringEncoding)
        //获取Users节点下的所有User节点，显示转换为elementl
//        let users:Array! = doc.rootElement().elementsForName("User") as! [GDataXMLElement]
        //通过XPath方式获取Users节点下的所有User节点(XPath是XML语言中的定位语法,类似于数据库中的SQL功能)
        let users:Array! = try? doc.nodesForXPath("//User") as! [GDataXMLElement]
        
        for user in users {
            //user的节点 id 属性
            let uid = user.attributeForName("id").stringValue()
            //获取name 的节点
            let nameElement = user.elementsForName("name")[0] as! GDataXMLElement
            let userName = nameElement.stringValue()
            
            //获取tel的子节点
            let telElement = user.elementsForName("tel")[0] as! GDataXMLElement
            //获取tel节点下的moblie和home节点
            let mobile = (telElement.elementsForName("mobile")[0] as! GDataXMLElement).stringValue()
            let home = (telElement.elementsForName("home")[0] as! GDataXMLElement).stringValue()
            
            //输出调试信息
            print("User: uid:\(uid),userName:\(userName), mobile:\(mobile),home:\(home)")
        }
        
        testSystemJSON()
        testJSONKit()
    }
    
    func testSystemJSON(){
        let user = ["name":"张江",
                    "tel":["mobile":"13967890987","home":"010-9078990"]]
        
        //判断对象能不能转换
        if (!NSJSONSerialization.isValidJSONObject(user)){
            print("\(user)")
            return
        }
        
        //利用OC中的json库进行转换
        let data:NSData! = try?NSJSONSerialization.dataWithJSONObject(user, options: .PrettyPrinted)
        //data转换成string输出
        let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
        print("转换之后的数据-----\(dataString)")
        
        //把data转换成json
        let jsonData:AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        print("Json Object is \(jsonData)")
        
        let name = jsonData.objectForKey("name")
        let mobile = jsonData.objectForKey("tel")?.objectForKey("mobile")
        let home = jsonData.objectForKey("tel")?.objectForKey("home")
        print("输出拿到的结果--- name:\(name),mobile :\(mobile),home:\(home)")
        
        
    }
    
    
    func testJSONKit(){
        let user:NSDictionary! = ["name":"张江",
            "tel":["mobile":"13967890987","home":"010-9078990"]]
        //使用jsonkit转换成json字符串
        let jsonString = (user as NSDictionary).JSONString()
        
        print("拿到的数据--- \(jsonString)")
        //使用jsonkit转换成nsdata类型的json数据
        let jsonData = (user as NSDictionary).JSONData()
        let testModel = MyTestModel()
        testModel.name = user.objectForKey("name")! as! String
        testModel.home = user.objectForKey("tel")!.objectForKey("home")! as! String
        testModel.mobile = user.objectForKey("tel")!.objectForKey("mobile")! as! String

        //data
        print("拿到的数据--- \(testModel),data:\(jsonData.objectFromJSONData())")
    }


}



