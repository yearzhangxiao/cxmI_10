//
//  MeComplaintVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit


class MeComplaintVC: BaseViewController {

    
    // MARK: - 点击事件
    @objc private func sendClicked(_ sender: UIButton) {
        print("发送")
    }
    
    // MARK: - 属性
    private var titleLB : UILabel!
    private var sendBut : UIButton! // 发送
    private var textView : HXTextView! // 投诉输入
    private var bgView: UIView!
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘·投诉建议"
        initSubview()
    }

    private func initSubview() {
        self.view.backgroundColor = ColorF4F4F4
        
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        titleLB = UILabel()
        titleLB.font = Font12
        titleLB.textColor = UIColor.black
        titleLB.numberOfLines = 5
        titleLB.text = """
        尊敬的上帝您好：
            请将您对我们产品的反馈内容输入下面输入框中，我们会认真对待您的每一条建议。谢谢您的反馈。如果您有在使用上不清楚的地方，请点击右上角联系人工客服进行咨询。
        """
        
        textView = HXTextView()
        textView.limitNumber = 140
        
        
        
        sendBut = UIButton(type: .custom)
        sendBut.setTitle("发送", for: .normal)
        sendBut.setTitleColor(ColorFFFFFF, for: .normal)
        sendBut.backgroundColor = ColorEA5504
        sendBut.layer.cornerRadius = 5
        sendBut.addTarget(self, action: #selector(sendClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(bgView)
        self.view.addSubview(sendBut)
        bgView.addSubview(titleLB)
        bgView.addSubview(textView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(SafeAreaTopHeight)
            make.left.right.equalTo(0)
            make.height.equalTo(220)
        }
        
        titleLB.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
            make.top.equalTo(bgView).offset(1)
        }
        textView.snp.makeConstraints { (make) in
            make.height.equalTo(120)
            make.left.right.equalTo(titleLB)
            make.top.equalTo(titleLB.snp.bottom).offset(10)
        }
        sendBut.snp.makeConstraints { (make) in
            make.height.equalTo(loginButHeight)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(bgView.snp.bottom).offset(loginButTopSpacing)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
