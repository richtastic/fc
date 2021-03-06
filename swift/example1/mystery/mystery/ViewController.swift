//  ViewController.swift

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {
    let NUMBER_OF_IMAGES:Int = 5
    var funView:UIView!
    var funViewTapCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        // CREATE TITLE FOR PAGE
        var textView:UILabel
        textView = UILabel()
        textView.frame = CGRectMake(20,20, self.view.frame.size.width-40, 60)
        textView.backgroundColor = UIColor.yellowColor()
        textView.text = "HELLO WORLD"
        textView.font = UIFont(name:"AvenirNext-Bold", size:20.0)
        textView.textAlignment = NSTextAlignment.Center
        textView.textColor = UIColor(red:0.0, green:0.5, blue:0.2, alpha:1.0)
        self.view.addSubview(textView)
        
        // CREATE SOME IMAGES TO LOOK AT - IN ROWS
        var string:String!
        var image:UIImage!
        var imageView:UIImageView!
        var rect:CGRect!
        var size:CGSize!
        
        string = "bunny.png"
        image = UIImage(named:string)
        size = image.size
        
        var i:Int
        var len:Int
        var currentY:CGFloat = 100.0
        len = NUMBER_OF_IMAGES
        for i=0; i<len; ++i {
            imageView = UIImageView(image: image) // multiple references to single image object
            self.view.addSubview(imageView)
            if i%2 == 0 { // left column
                imageView.frame = CGRectMake(10,currentY, size.width, size.height)
            } else { // right column
                imageView.frame = CGRectMake(self.view.frame.size.width - size.width - 10,currentY, size.width, size.height)
                imageView.transform = CGAffineTransformMakeScale(0.5, 0.5)
            }
            if i%2 == 1 {
                currentY += size.height + 20.0
            }
        }
        
        
        // ADD A BUTTON TO INTERACT WITH
        var button:UIButton!
        
        button = UIButton()
        button.backgroundColor = UIColor.redColor()
        button.frame = CGRectMake(20, 100, self.view.frame.size.width-40, 40)
        button.setTitle("CLICK ME", forState: UIControlState.Normal)
        button.setTitle("HIGHLIGHTED", forState: UIControlState.Highlighted)
        button.setTitleColor(UIColor.blackColor(), forState:UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Highlighted)
        self.view.addSubview(button)
        
        
        // ASSIGN BUTTON AN ACTION TO PERFORM
        button.addTarget(self, action:"handleMainButtonWasTapped:", forControlEvents:UIControlEvents.TouchUpInside)
        
        
        // GESTURE RECOGNITION
        var swipeRecognizer:UISwipeGestureRecognizer! = UISwipeGestureRecognizer()
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Down
        swipeRecognizer.numberOfTouchesRequired = 2
        swipeRecognizer.addTarget(self, action:"handleSwipeWasTriggered:")
        self.view.addGestureRecognizer(swipeRecognizer)
        
        
        // LOAD FROM URL (w/o AF)
        var url:NSURL! = NSURL(string:"http://tn.clashot.com/thumbs/2917365/53191154/thumb_200.jpg")
        var request:NSURLRequest = NSURLRequest(URL:url)
        var config:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var session:NSURLSession = NSURLSession(configuration:config)
        var task:NSURLSessionDataTask = session.dataTaskWithURL(url, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            println("async called")
            // have to get main thread or processing/UI is slow (lower priority)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                var webImage:UIImage! = UIImage(data:data)
                if webImage != nil {
                    var webImageView:UIImageView! = UIImageView(image: webImage)
                    webImageView.frame = CGRectMake((self.view.frame.size.width-webImage.size.width)*0.5, (self.view.frame.size.height-webImage.size.height)*0.5, webImage.size.width, webImage.size.height)
                    self.view.addSubview(webImageView)
                    self.funView = webImageView
                    var button:UIButton! = UIButton(frame:CGRectMake(0,0,webImage.size.width, webImage.size.height))
                    button.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.25)
                    webImageView.addSubview(button)
                    button.addTarget(self, action:"handleFunViewButtonTapped:", forControlEvents:UIControlEvents.TouchUpInside)
                    webImageView.userInteractionEnabled = true
                }
            })
        })
        task.resume()
        
        
        // DO WHILE LOOP
        var j:Int = 0
        var maxIterations:Int = 4
        
        do {
            println("j: \(j)")
            ++j
        } while j < maxIterations
        
        
        // REGULAR WHILE LOOP
        j = 0
        while j < 4 {
            println("j: \(j)")
            ++j
        }
        
        
        // ADD INPUT FIELDS TO GET USER DATA
        var listTitles:[(String,String,String)] = [("first name","string","Richie"), ("last name","string",""), ("age","number","24")]
        currentY = 300.0
        for (key, val) in enumerate(listTitles) {
            var dataLabel = val.0
            var dataType = val.1
            var dataValue = val.2
            
            println("make an input field: \(val)")
            var label:UILabel!
            label = UILabel()
            label.frame = CGRectMake(0, currentY, 100, 32)
            label.text = dataLabel
            label.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(label)
            
            var input:UITextField!
            input = UITextField()
            input.text = dataValue
            input.frame = CGRectMake(100, currentY, 150, 32)
            input.delegate = self
            input.layer.cornerRadius = 4.0
            input.layer.borderColor = UIColor.blackColor().CGColor
            input.layer.borderWidth = 2.0
            input.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
            input.tintColor = UIColor.blackColor();
            input.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
            input.textAlignment = NSTextAlignment.Center
            input.placeholder = "enter here"
            input.clearButtonMode = UITextFieldViewMode.Never
            input.keyboardType = UIKeyboardType.Default
            input.returnKeyType = UIReturnKeyType.Done
            if dataType == "number" {
                input.keyboardType = UIKeyboardType.DecimalPad
                input.returnKeyType = UIReturnKeyType.Go
            }
            input.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(input)

            currentY += 40
        }
        
        
        // PASS-BY-VALUE vs PASS-BY-REFERENCE in functions
        var myArrayA:[String]!
        var myArrayB:[String]!
        
        myArrayA = ["A","B","C"]
        println("myArrayA Before: \(myArrayA)")
        testPassByValue(myArrayA)
        println("myArrayA After:  \(myArrayA)")
        
        myArrayB = ["A","B","C"]
        println("myArrayB Before: \(myArrayB)")
        testPassByReference(&myArrayB)
        println("myArrayB After:  \(myArrayB)")
    }
    func testPassByValue(var arr:[String]!) {
        arr.append("added")
        println("  inside: \(arr)")
    }
    func testPassByReference(inout arr:[String]!) {
        arr.append("added")
        println("  inside: \(arr)")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        var value:String! = textField.text
        var result:String! = "RESULT: \""+textField.text+"\""
        var alert:UIAlertController = UIAlertController(title:"field changed", message:result, preferredStyle:UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler: self.alertHandlerFxn)) // alternative
        alert.addAction(UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            switch action.style {
            case .Default:
                println("default")
            case .Cancel:
                println("cancel")
            case .Destructive:
                println("destruct")
            }
        }))
        self.presentViewController(alert, animated:true) { () -> Void in
            println("presented")
        }
    }
    func alertHandlerFxn(action:UIAlertAction!) -> Void {
        println("diff")
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        return true
    }
    // ALERTVIEWDELEGATE
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println("button pressed: \(buttonIndex)")
    }
    
    // STACK PUSH
    func handleMainButtonWasTapped(button:UIButton) {
        self.presentDuplicateController()
    }
    func presentDuplicateController() {
        var controller:ViewController = ViewController()
        self.presentViewController(controller, animated:true) { () -> Void in
            println("presented")
        }
    }
    
    // STACK POP
    func handleSwipeWasTriggered(gestureRecognizer:UISwipeGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            self.unpresentSelfController()
        }
    }
    func unpresentSelfController() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("dismissed")
        })
    }
    
    // BUTTON ANIMATIONS
    func handleFunViewButtonTapped(button:UIButton) {
        var duration:NSTimeInterval = 1.0 // 1 second
        var delay:NSTimeInterval = 0.0
        var options:UIViewAnimationOptions = UIViewAnimationOptions.CurveEaseInOut
        UIView.animateWithDuration(duration, delay:delay, options:options, animations: { () -> Void in
            // animation final results go here
            var frame:CGRect = self.funView.frame
            switch self.funViewTapCount {
                case 0:
                    frame.origin.x = 0
                    frame.origin.y = 0
                case 1:
                    frame.origin.x = self.view.frame.size.width - frame.size.width
                    frame.origin.y = 0
                case 2:
                    frame.origin.x = self.view.frame.size.width - frame.size.width
                    frame.origin.y = self.view.frame.size.height - frame.size.height
                case 3:
                    frame.origin.x = 0
                    frame.origin.y = self.view.frame.size.height - frame.size.height
                default:
                    println("unknown action")
            }
            self.funView.frame = frame
            
            ++self.funViewTapCount
            
            if self.funViewTapCount > 3 {
                self.funViewTapCount = 0
            }
            
        }) { (didComplete:Bool) -> Void in
            // animation completed
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

/*

string = "bunny.png"
println("F: \(filename)")
//filename = NSBundle.mainBundle().pathForResource(string, ofType:nil)
println("FILENAME: \(filename)")
image = UIImage(contentsOfFile:filename)
println("IMAGE: \(image)")
imageView = UIImageView(image: image)

self.view.addSubview(imageView)

*/
