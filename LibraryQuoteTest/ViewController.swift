//
//  ViewController.swift
//  LibraryQuoteTest
//
//  Created by zjhaha on 16/1/6.
//  Copyright © 2016年 zjhaha. All rights reserved.
//http://blog.csdn.net/b719426297/article/details/22859181

import UIKit
import CoreMotion


let KScreenWidth:CGFloat = UIScreen.mainScreen().bounds.width
let KScreenHeight:CGFloat = UIScreen.mainScreen().bounds.height
let KImageWH:CGFloat = 50
class ViewController: UIViewController,AwesomeMenuDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate {
    //控制小球
    var pickerView = UIPickerView()
    var ballImage = UIImageView()
    var speedX:UIAccelerationValue = 0
    var speedY:UIAccelerationValue = 0
    var motionManager = CMMotionManager()
    
    //倒计时
    var countDatePicker = UIDatePicker()
    var leftTime:Int = 180
    var timer:NSTimer!
    var timeLabel:UILabel!
    var startBtn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏不遮挡状态
        self.edgesForExtendedLayout = UIRectEdge.None;
        self.extendedLayoutIncludesOpaqueBars = false;
        self.modalPresentationCapturesStatusBarAppearance = false;
        self.title = "Swift测试"
        testControlUI8()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    /**
     测试控件的用法
     */
    func testControlUI1() {
        let label = UILabel(frame: CGRectMake(10,20,300,100))
        label.text = "《Swift语言开发实践》"
        label.textAlignment = NSTextAlignment.Center
        label.shadowColor = UIColor.grayColor()
        label.shadowOffset = CGSizeMake(-2, 2)
        self.view.addSubview(label);

    }
    
    /**
     添加滑动块
     */
    func testControlUI2(){
        
        let slider = UISlider(frame: CGRectMake(10,150,KScreenWidth-20,50))
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.8
        slider.addTarget(self, action: "sliderValueChange:", forControlEvents: UIControlEvents.ValueChanged)
        slider.minimumTrackTintColor = UIColor.blueColor()
        slider.maximumTrackTintColor = UIColor.redColor()
        self.view.addSubview(slider)

    }
    
    /**
     添加弹出框
     */
    func testControlUI3(){
        
        let alertView = UIAlertController(title: "事件提醒", message: "本地服务通知您的一切事物已经准备好", preferredStyle: UIAlertControllerStyle.Alert)
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
     添加pickerView
     */
    func testControlUI4(){
        pickerView.delegate   = self
        pickerView.dataSource = self
        //设置默认值
        pickerView.selectRow(1, inComponent: 0, animated: true)
        pickerView.selectRow(2, inComponent: 1, animated: true)
        pickerView.selectRow(3, inComponent: 2, animated: true)
        self.view.addSubview(pickerView)
    }
    
    /**
     添加滚动视图
     */
    func testControlUI5(){
        let viewWidth:CGFloat = UIScreen.mainScreen().bounds.width
        //添加UIScrollView
        let scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.contentSize = CGSizeMake(KScreenWidth*5, KScreenHeight)
        scrollView.pagingEnabled = true
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 0.5
        scrollView.delegate = self
        
        for i in 0..<5  {
            let backView:UIView = UIView(frame: CGRectMake(viewWidth * CGFloat(i),0.0 ,KScreenWidth,KScreenHeight))
            backView.backgroundColor = getRandomColor()
            
            scrollView.addSubview(backView)
        }
        self.view.addSubview(scrollView)
    }
    
    /**
    添加一个滚动的小球
    */
    func testControlUI6(){
        ballImage = UIImageView(image: UIImage(named: "scrollBall6"))
        ballImage.center = self.view.center
        ballImage.bounds = CGRectMake(0, 0, KImageWH, KImageWH);
        ballImage.layer.masksToBounds = true
        ballImage.layer.cornerRadius = KImageWH/2
        self.view.addSubview(ballImage)
        
        //设置更新时间
        motionManager.accelerometerUpdateInterval = 1/60
        if (motionManager.accelerometerAvailable){
            let queue = NSOperationQueue.currentQueue()
            
            motionManager.startAccelerometerUpdatesToQueue(queue!, withHandler:
                { (accelerometerData:CMAccelerometerData?, error: NSError?) -> Void in
                //动态设置小球位置
                self.speedX += accelerometerData!.acceleration.x
                self.speedY += accelerometerData!.acceleration.y
                
                var posX = self.ballImage.center.x + CGFloat(self.speedX)
                var posY = self.ballImage.center.y + CGFloat(self.speedY)
                
                //碰到边框后的反弹处理
                if posX < KImageWH/2{
                    posX = KImageWH/2
                    //碰到左边的边框以0.4倍的速度反弹
                    self.speedX *= -0.4
                }else if posX > KScreenWidth - KImageWH/2{
                    posX = KScreenWidth - KImageWH/2
                    //碰到右边的边框以0.4倍的速度反弹
                    self.speedX *= -0.4
                }
                
                if posY < KImageWH/2{
                    posY = KImageWH/2
                    //碰到上边的边框以0.4倍的速度反弹
                    self.speedY *= -0.6
                }else if posY > KScreenHeight - KImageWH/2{
                    posY = KScreenHeight - KImageWH/2
                    //碰到下边的边框以0.4倍的速度反弹
                    self.speedY *= -0.6
                }
                self.ballImage.center = CGPointMake(posX, posY)
             })
        }
        
    }
    
    
    
    /**
     添加时间选择器
     */
    func testControlUI7(){
    
        let datePick =  UIDatePicker(frame: CGRectMake(0, 0, KScreenWidth, 200))
        datePick.addTarget(self, action: "datePickerValueChange:", forControlEvents: UIControlEvents.ValueChanged)
        datePick.datePickerMode = UIDatePickerMode.Date
        let dataFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd"
        let minDate = dataFormatter.dateFromString("1990-01-01")
        let maxDate = dataFormatter.dateFromString("2022-01-01")
        datePick.minimumDate = minDate
        datePick.maximumDate = maxDate
        self.view.addSubview(datePick)
    }
    
    func datePickerValueChange(datePick:UIDatePicker){
        let dateFormatter = NSDateFormatter()
        let date = datePick.date
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print("当前选择的时间---\(dateFormatter.stringFromDate(date))")
    }
    
    
    /**
     倒计时的pickerView
     */
    func testControlUI8(){
        countDatePicker =  UIDatePicker(frame: CGRectMake(0, 0, KScreenWidth, 200))
        countDatePicker.addTarget(self, action: "datePickerValueChange1:", forControlEvents: UIControlEvents.ValueChanged)
        countDatePicker.datePickerMode = UIDatePickerMode.CountDownTimer
        //leftTime必须为60的整数倍，设置值为100时，值自动变成60
        countDatePicker.countDownDuration = NSTimeInterval(leftTime);// leftTime
        self.view.addSubview(countDatePicker)
        
        //添加一个按钮
        startBtn = UIButton(frame: CGRectMake(40, 220, KScreenWidth-80, 40))
        startBtn.setTitle("开始", forState: .Normal)
        startBtn.backgroundColor = UIColor.init(red: 0/255.0, green: 150/255.0, blue: 250/255.0, alpha: 1)
        startBtn.layer.cornerRadius = 5;
        startBtn.layer.masksToBounds = true
        startBtn.addTarget(self, action: "startCount:", forControlEvents: .TouchUpInside)
        self.view.addSubview(startBtn)
        
        //显示时间Label
        timeLabel = UILabel(frame: CGRectMake(40, 280, KScreenWidth-80, 40))
        timeLabel.font = UIFont.systemFontOfSize(17)
        timeLabel.textAlignment = NSTextAlignment.Center
        timeLabel.textColor = UIColor.blackColor()
        self.view.addSubview(timeLabel)
    }
    
    /**
     倒计时
     */
    func datePickerValueChange1(datePick:UIDatePicker){
        
        print("倒计时"+String(datePick.countDownDuration))
    }
    
    func startCount(sender:UIButton){
    
        sender.enabled = false
        sender.setTitle("倒计时中……", forState: .Normal)
        sender.backgroundColor = UIColor.grayColor()
        //显示剩下的时间
        timeLabel.text = "倒计时"+String(leftTime)
        //获取倒计时器的剩余时间
        leftTime = Int(countDatePicker.countDownDuration)
        //禁用datePicker
        countDatePicker.enabled = false
        
        //每隔60s执行一次
        timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1), target: self, selector: "tickDown", userInfo: nil, repeats: true)
    
    }
    
    func tickDown(){
        //将时间减少
        leftTime -= 1
        countDatePicker.countDownDuration = NSTimeInterval(leftTime)
        timeLabel.text = "倒计时"+String(leftTime)
        if leftTime < 0 {
            leftTime = 180
            timer.invalidate()
            countDatePicker.enabled = true
            startBtn.enabled = true
            startBtn.setTitle("开始", forState: .Normal)
            startBtn.backgroundColor = UIColor.init(red: 0/255.0, green: 150/255.0, blue: 250/255.0, alpha: 1)
            timeLabel.text = "倒计时0"
        }
        
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
    
    
    
    //pickView的代理方法
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 9
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)+"---"+String(component)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectStr = String(row)+"---"+String(component)
        
        print("当前选用 \(selectStr)")
    }
    
    //scrollView的代理方法
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        for subview:AnyObject in scrollView.subviews{
            if subview.isKindOfClass(UIImageView){
                return subview as? UIView
            }
        }
        return nil
    }
    
    /**
     随机化颜色值
     */
    func getRandomColor()-> UIColor?{
        let red   = Float(random()%255) / 255.0
        let green = Float(random()%255) / 255.0
        let blue  = Float(random()%255) / 255.0
        
        return UIColor.init(colorLiteralRed: red, green: green, blue: blue, alpha: 1)
    }

}



