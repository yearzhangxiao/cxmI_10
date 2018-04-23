//
//  MainTabBarController.swift
//  彩小蜜
//
//  Created by HX on 2018/2/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UserInfoPro {

    //private var configInfo : ConfigInfoModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func configRequest() {
        //weak var weakSelf = self
        _ = userProvider.rx.request(.configQuety)
            .asObservable()
            .mapObject(type: ConfigInfoModel.self)
            .subscribe(onNext: { (data) in
                //DispatchQueue.main.async {
                    self.creatSubViewControllers(data.turnOn)
                //}
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult: break
                    
                    //self.showHUD(message: msg!)
                default: break
                }
                //DispatchQueue.main.async {
                    self.creatSubViewControllers(true)
                //}
                
            }, onCompleted: nil, onDisposed: nil )
    }
    
    public func creatSubViewControllers(_ turnOn: Bool)
    {
        // 主页
        let home = HomeViewController()
        
        if turnOn {
            home.homeStyle = .allShow
        }else {
            home.homeStyle = .onlyNews
        }
        
        
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        homeNav.title = ""
    
        homeNav.view.backgroundColor = UIColor.white
        
        let homeImage = UIImage(named: "tab_home_nor")?.withRenderingMode(.alwaysOriginal)
        let homeSelectImage = UIImage(named: "tab_home_sel")?.withRenderingMode(.alwaysOriginal)
        
        homeNav.tabBarItem.image = homeImage
        homeNav.tabBarItem.selectedImage = homeSelectImage
        homeNav.tabBarItem.title = ""
        
        
        // 开奖
        let lottery = LotteryViewController()
        
        let lotteryNav = UINavigationController(rootViewController: lottery)
        lotteryNav.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        
        lotteryNav.view.backgroundColor = UIColor.white
        
        let loImg = UIImage(named: "tab_lot_nor")?.withRenderingMode(.alwaysOriginal)
        let loSelImg = UIImage(named: "tab_lot_sel")?.withRenderingMode(.alwaysOriginal)
        
        lotteryNav.tabBarItem.image = loImg
        lotteryNav.tabBarItem.selectedImage = loSelImg
        
        // me
        var me : BaseViewController!
        
        if getUserData() != nil {
            if turnOn {
                me = MeViewController()
            }else {
                me = NewsMeViewController()
            }
        }else {
            me = LoginViewController()
        }
        
        let meNav = UINavigationController(rootViewController: me)
        meNav.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        meNav.view.backgroundColor = UIColor.white
        
        let meImg = UIImage(named: "tab_min_nor")?.withRenderingMode(.alwaysOriginal)
        let meSelImg = UIImage(named: "tab_min_sel")?.withRenderingMode(.alwaysOriginal)
        
        meNav.tabBarItem.image = meImg
        meNav.tabBarItem.selectedImage = meSelImg
        
        
        self.viewControllers = [homeNav, lotteryNav, meNav]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
