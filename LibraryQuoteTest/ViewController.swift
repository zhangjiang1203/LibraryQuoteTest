//
//  ViewController.swift
//  LibraryQuoteTest
//
//  Created by zjhaha on 16/1/6.
//  Copyright © 2016年 zjhaha. All rights reserved.
//

import UIKit
let KScreenWidth = UIScreen.mainScreen().bounds.width
let KScreenHeight = UIScreen.mainScreen().bounds.height
class ViewController: UIViewController,AwesomeMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        testControlUI()
        
        
    }
    
    /**
     测试控件的用法
     */
    func testControlUI() {
        let label = UILabel(frame: CGRectMake(10,20,300,100))
        label.text = "《Swift语言开发实践》"
        label.textAlignment = NSTextAlignment.Center
        label.shadowColor = UIColor.grayColor()
        label.shadowOffset = CGSizeMake(-2, 2)
        self.view.addSubview(label);
        
        
        UIScreen.mainScreen().bounds.width
        let slider = UISlider(frame: CGRectMake(10,150,KScreenWidth-20,50))
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.8
        slider.addTarget(self, action: "sliderValueChange:", forControlEvents: UIControlEvents.ValueChanged)
        slider.minimumTrackTintColor = UIColor.blueColor()
        slider.maximumTrackTintColor = UIColor.redColor()
        self.view.addSubview(slider)
        
        //添加弹出框
        let alertView = UIAlertController(title: "事件提醒", message: "本地服务通知您的一切事物已经准备好", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default,
            handler: {
                action in
                print("点击了确定")
        })
        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
        
    
        
        
    }
    
    /**
     slider滑块
     */
    func sliderValueChange(slider:UISlider) {
        print("输出这个值的---\(slider.value)")
    }
    
    
    /**
     * 测试XML解析
     */
    func testGDataXML(){
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
    }
    
    /**
     测试系统json解析
     */
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
    
    /**
     使用第三方类库经行解析
     */
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
    
    
    /**
     仿path菜单
     */
    func addPathButtonAnimation() {
        let storyImage = UIImage(named: "bg-menuitem");
        let storyHeightImage = UIImage(named: "bg-menuitem-highlighted")
        
        let startImage = UIImage(named: "icon-star");
        
        let awesomeItem1 = AwesomeMenuItem(image: storyImage, highlightedImage: storyHeightImage, contentImage: startImage, highlightedContentImage: nil)
        
        let awesomeItem2 = AwesomeMenuItem(image: storyImage, highlightedImage: storyHeightImage, contentImage: startImage, highlightedContentImage: nil)
        
        let awesomeItem3 = AwesomeMenuItem(image: storyImage, highlightedImage: storyHeightImage, contentImage: startImage, highlightedContentImage: nil)
        
        let awesomeItem4 = AwesomeMenuItem(image: storyImage, highlightedImage: storyHeightImage, contentImage: startImage, highlightedContentImage: nil)
        
        let awesomeItem5 = AwesomeMenuItem(image: storyImage, highlightedImage: storyHeightImage, contentImage: startImage, highlightedContentImage: nil)
        
        let itemArr = [awesomeItem1,awesomeItem2,awesomeItem3,awesomeItem4,awesomeItem5]
        
        let menuItem = AwesomeMenuItem(image: UIImage(named: "bg-addbutton"), highlightedImage: UIImage(named: "bg-addbutton-highlighted"), contentImage: UIImage(named: "icon-plus"), highlightedContentImage: UIImage(named: "icon-plus-highlighted"))
        
        
        
        let menu = AwesomeMenu(frame: self.view.bounds, startItem: menuItem, menuItems: itemArr)
        menu.delegate  = self
        menu.menuWholeAngle = 1.345
        menu.farRadius = 110.0
        menu.endRadius = 100.0
        menu.nearRadius = 90.0
        menu.animationDuration = 0.3
        menu.startPoint = CGPointMake(50.0, 410.0);
        self.view.addSubview(menu);
        
    }
    //实现的代理方法
    func awesomeMenu(menu: AwesomeMenu!, didSelectIndex idx: Int) {
        print("点击的是哪个按钮---\(idx)")
    }
    
    func awesomeMenuDidFinishAnimationClose(menu: AwesomeMenu!) {
        print("按钮动画结束---")
    }
    
    func awesomeMenuDidFinishAnimationOpen(menu: AwesomeMenu!) {
        print("按钮动画结束打开---")
    }
    
    func awesomeMenuWillAnimateClose(menu: AwesomeMenu!) {
        print("菜单按钮将要关闭---")
    }
    
    func awesomeMenuWillAnimateOpen(menu: AwesomeMenu!) {
        print("菜单按钮将要打开---")
    }

}



