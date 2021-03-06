//
//  AppDelegate.swift
//  彩小蜜
//
//  Created by HX on 2018/2/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import UserNotifications
import PushKit


let device = DeviceManager.share.device

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppDelegateProtocol, GeTuiSdkDelegate, UNUserNotificationCenterDelegate, GuideViewControllerDelegate {

    var window: UIWindow?
    
    var rootViewController : MainTabBarController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        rootViewController = MainTabBarController()
        //UserDefaults.standard.set(false, forKey: ShowGuided)
        if UserDefaults.standard.bool(forKey: ShowGuided) == false {
            UserDefaults.standard.set(true, forKey: ShowGuided)
            let guide = GuideViewController()
            guide.delegate = self
            self.window?.rootViewController = guide
        }else {
            self.window?.rootViewController = rootViewController
        }
        
        self.window?.makeKeyAndVisible()
        
        registerApp()
  
        if let agent = UIWebView.init().stringByEvaluatingJavaScript(from: "navigator.userAgent") {
            let newAgent = agent + "app/ios&"
            UserDefaults.standard.register(defaults: ["UserAgent": newAgent])
        }
        
        return true
    }

    func didTipGuide() {
        let main = MainTabBarController()
        self.window?.rootViewController = main
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if UserDefaults.standard.bool(forKey: ShowGuided) {
            guard self.rootViewController != nil else { return }
            self.rootViewController.getAppConfigRequest()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationWillEnterForeground), object: nil)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        WeixinCenter.share.weixinHandle(url: url)
        
        return true
    }
    //MARK: - 个推
    func geTuiSdkDidSendMessage(_ messageId: String!, result: Int32) {
        
    }
    // 透传消息
    func geTuiSdkDidReceivePayloadData(_ payloadData: Data!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        var payloadMsg = ""
        if payloadData != nil {
            payloadMsg = String.init(data: payloadData, encoding: String.Encoding.utf8)!
        }
        
        let msg:String = "Receive Payload: \(payloadMsg), taskId:\(taskId), messageId:\(msgId)"
    }
    
    /** 远程通知注册成功委托 */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken_ns = NSData.init(data: deviceToken);    // 转换成NSData类型
        var token = deviceToken_ns.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>"));
        token = token.replacingOccurrences(of: " ", with: "")
        
        // [ GTSdk ]：向个推服务器注册deviceToken
        GeTuiSdk.registerDeviceToken(token);
        
        // 智齿客服 注册token
        ZCLibClient.getZCLibClient().token = deviceToken
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func geTuiSdkDidRegisterClient(_ clientId: String!) {
        UserDefaults.standard.set(clientId, forKey: ClientId)
        NSLog("\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    }
}

