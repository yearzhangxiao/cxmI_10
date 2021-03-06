//
//  MessageCenterCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class MessageCenterCell: UITableViewCell {

    public var messageModel: MessageCenterModel! {
        didSet{
            guard messageModel != nil else { return }
            titleLB.text = messageModel.title
            timeLB.text = messageModel.sendTime
            moneyLB.text = messageModel.content
           
            stateLB.text = messageModel.contentDesc
            
            moneyLB.textColor = ColorE95504
            
            let msgDescs = messageModel.msgDesc.components(separatedBy: "#")
            var msgD = ""
            for msg in msgDescs {
                msgD += msg + "\n"
            }
            
            detailLB.text = msgD
//            switch messageModel.objectType {
//            case "0":
//                moneyLB.textColor = ColorE95504
//            default:
//                moneyLB.textColor = Color505050
//            }
            
        }
    }
    
    private var titleLB : UILabel!
    private var moneyLB : UILabel!
    private var timeLB : UILabel!
    private var stateLB: UILabel!
    private var detailLB: UILabel!
    
    private var detailTitle : UILabel!
    private var detailIcon : UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
        detailTitle.isHidden = true
        detailIcon.isHidden = true 
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.textColor = Color9F9F9F
        titleLB.textAlignment = .left
        //titleLB.text = "中奖通知"
        
        moneyLB = UILabel()
        moneyLB.font = Font13
        moneyLB.textColor = ColorEA5504
        moneyLB.textAlignment = .left
        //moneyLB.text = "中奖3000.00元"
        
        timeLB = UILabel()
        timeLB.font = Font12
        timeLB.textColor = Color787878
        timeLB.textAlignment = .right
        //timeLB.text = "01月30日 08： 30"
        
        detailLB = UILabel()
        detailLB.font = Font12
        detailLB.textColor = Color9F9F9F
        detailLB.textAlignment = .left
        detailLB.numberOfLines = 0
//        detailLB.text =
//        """
//        彩种： 精彩足球
//        投注金额： 50.00元
//        投注时间： 2018年02月03日
//        """
        
        stateLB = UILabel()
        stateLB.font = Font13
        stateLB.textColor = Color787878
        stateLB.textAlignment = .left
        //stateLB.text = "奖金已打入您的可用余额"
        
        detailTitle = UILabel()
        detailTitle.font = Font13
        detailTitle.textColor = Color9F9F9F
        detailTitle.textAlignment = .right
        detailTitle.text = "查看详情"
        
        detailIcon = UIImageView()
        detailIcon.image = UIImage(named: "jump")
        
        self.contentView.addSubview(titleLB)
        self.contentView.addSubview(timeLB)
        self.contentView.addSubview(moneyLB)
        self.contentView.addSubview(stateLB)
        self.contentView.addSubview(detailLB)
        self.contentView.addSubview(detailTitle)
        self.contentView.addSubview(detailIcon)
        
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(13 * defaultScale)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.width.equalTo(100 * defaultScale)
            make.height.equalTo(15 * defaultScale)
        }
        moneyLB.snp.makeConstraints { (make) in
            make.top.equalTo(titleLB.snp.bottom).offset(5)
            make.left.height.equalTo(titleLB)
            make.right.equalTo(self.contentView.snp.centerX).offset(-20)
        }
        timeLB.snp.makeConstraints { (make) in
            make.top.equalTo(titleLB)
            make.left.equalTo(titleLB.snp.right).offset(10)
            make.right.equalTo(self.contentView).offset(-23 * defaultScale)
            make.height.equalTo(10 * defaultScale)
        }
        
        detailLB.snp.makeConstraints { (make) in
            make.top.equalTo(moneyLB.snp.bottom).offset(13 * defaultScale)
            make.left.equalTo(moneyLB)
            make.right.equalTo(stateLB)
            make.bottom.equalTo(stateLB.snp.top).offset(-13 * defaultScale)
        }
        
        stateLB.snp.makeConstraints { (make) in
            make.left.equalTo(detailLB)
            make.height.equalTo(12 * defaultScale)
            make.bottom.equalTo(-10 * defaultScale)
            make.right.equalTo(detailTitle.snp.left).offset(-10)
        }
        detailTitle.snp.makeConstraints { (make) in
            make.bottom.equalTo(stateLB)
            make.height.equalTo(timeLB)
            make.width.equalTo(100)
            make.right.equalTo(detailIcon.snp.left).offset(1)
        }
        detailIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(detailTitle.snp.centerY)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.height.width.equalTo(12)
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
