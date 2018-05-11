//
//  GuideViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/11.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController, UIScrollViewDelegate {

    var imageList : [String] = ["guide", "guide", "guide"]
    
    var scrollView : UIScrollView!
    
    var startBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorFFFFFF
        initSubview()
        self.startBut.isHidden = true
    }
 
    @objc private func startButClicked(_ sender: UIButton) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        if scrollView.contentOffset.x >= CGFloat(screenWidth * CGFloat(self.imageList.count - 1)) {
            self.startBut.isHidden = false
        }else {
            self.startBut.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func initSubview() {
        
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(self.imageList.count), height: screenHeight)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        
        for i in 0..<self.imageList.count {
            let image = imageList[i]
            let imv = initImageView(image: image)
            imv.frame = CGRect(x: CGFloat(i) * screenWidth, y: 0, width: screenWidth, height: screenHeight)
            scrollView.addSubview(imv)
        }
        
        startBut = UIButton()
        
        startBut.setTitle("求你点我吧", for: .normal)
        startBut.setTitleColor(ColorEA5504, for: .normal)
        startBut.addTarget(self, action: #selector(startButClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(startBut)
        
        startBut.snp.makeConstraints { (make) in
            make.bottom.equalTo(-100)
            make.height.equalTo(44 * defaultScale)
            make.width.equalTo(120 * defaultScale)
            make.centerX.equalTo(self.view.snp.centerX)
        }
    }
    
    private func initImageView(image: String) -> UIImageView {
        let imageView = UIImageView()
     
        imageView.image = UIImage(named: image)
        
        return imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
