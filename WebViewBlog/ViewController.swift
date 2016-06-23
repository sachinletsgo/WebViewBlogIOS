//
//  ViewController.swift
//  WebViewBlog
//
//  Created by Sachin Tyagi on 6/21/16.
//  Copyright © 2016 Sachin Tyagi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set delegate
        webView.delegate = self
        
        // call webview URL
        self.callWebView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //// Process for working
    func callWebView(){
    
        var send_data:[String:String] = [String:String]()
        send_data["name"] = "Sachin Tyagi"
        
        do
        {
            let json = try NSJSONSerialization.dataWithJSONObject(send_data, options: NSJSONWritingOptions(rawValue: 0))
            let data_string = NSString(data: json, encoding:NSUTF8StringEncoding)
            
            let url = NSURL (string: "http://stage.voicetree.info/for_sachin/index.php" )
            
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let post: String = "data=" + (data_string as! String)
            let postData: NSData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
            
            request.HTTPBody = postData
            webView.loadRequest(request)
            
                        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
                        dispatch_after(time, dispatch_get_main_queue()) {
                            //put your code which should be executed with a delay here
                            do{
                            let doc = self.webView.stringByEvaluatingJavaScriptFromString("document.documentElement.outerHTML")!
            
                           print("document JSON  = \(doc)")
            
                           let startIndexJSON  = doc.rangeOfString("{")?.startIndex
                           let endIndexJSON  = doc.rangeOfString("}")?.startIndex
                          
                                if startIndexJSON != nil && endIndexJSON != nil {
                                    let finalJson =  try doc.substringWithRange(Range<String.Index>(start: startIndexJSON!, end: endIndexJSON!.advancedBy(1)))
            
                                    print("\n\n finaJson JSON  = \(finalJson)")
                                    self.extract_json_data(finalJson.dataUsingEncoding(NSUTF8StringEncoding)!)
            
                                }
                            }
                            catch{}
                        }
        }
        catch{}
    }
    
    
    func extract_json_data(data:NSData)
    {
        var json: AnyObject?
        
        do
        {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        }
        catch
        {
            return
        }
        
        guard let data_dictionary = json as? NSDictionary else
        {
            return
        }
        
        guard let name = data_dictionary["name"] as? String else
        {
            return
        }
       
            print("Your name is  \(name) ")
            
        
    }



}

