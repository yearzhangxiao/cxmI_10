//
//  OfflineOrderDetailHeaderView.swift
//  彩小蜜
//
//  Created by Kairui Wang on 2019/5/29.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit

protocol OfflineOrderDetailHeaderViewDelegate {
    func didTipDualPayment() -> Void
}


class OfflineOrderDetailHeaderView: UIView {

    public var delegate : OfflineOrderDetailHeaderViewDelegate!
    
    public var orderInfo: OrderInfoModel! {
        didSet{
            guard orderInfo != nil else { return }
            if let url = URL(string: orderInfo.lotteryClassifyImg){
                icon.kf.setImage(with: url)
            }
            //icon.image = UIImage(named: "Racecolorfootball")
            
            
            let moneyAtt = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: Font10])
            let money = NSAttributedString(string: orderInfo.ticketAmount + "元")
            moneyAtt.append(money)
            
            titleLB.text = orderInfo.lotteryClassifyName
            moneyLB.attributedText = moneyAtt
            programmeLB.text = orderInfo.orderStatusDesc
            
            if orderInfo.forecastMoney != ""{
//                orderInfo.forecastMoney + "元"
                forecastMoney.text =  orderInfo.forecastMoney.replacingOccurrences(of: "预测金额", with: "预测金额/n") + "元"
            }else{
                forecastMoney.text = orderInfo.forecastMoney
            }
            
            if orderInfo.orderStatus == "5" {
                setWinMoney()
                if orderInfo.processStatusDesc != ""{
                    winMoney.text = orderInfo.processStatusDesc + ""
                }else{
                    winMoney.text = orderInfo.processStatusDesc
                }
                state.text = orderInfo.processResult
                state.textColor = ColorEA5504
            }else if orderInfo.orderStatus == "9" {
                setWinMoney()
                winTitle.text = "派奖金额"
                if orderInfo.processStatusDesc != ""{
                    winMoney.text = orderInfo.processStatusDesc + ""
                }else{
                    winMoney.text = orderInfo.processStatusDesc
                }
                state.text = orderInfo.processResult
                state.textColor = ColorEA5504
                
            }else{
                thankLB.text = orderInfo.processStatusDesc
                state.text = orderInfo.processResult
            }
        }
    }
    
    private var icon : UIImageView!
    private var titleLB : UILabel!
    private var moneyLB : UILabel!
    private var line : UIView!
    private var state : UILabel!
    private var forecastMoney: UILabel!
    private var programmeTitle : UILabel!
    private var programmeLB : UILabel!
    private var thankLB : UILabel!

    private var winTitle: UILabel!
    private var winMoney: UILabel!
    
    public var countdownLB : UILabel!
    private var countdownBut : UIButton!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: OrderHeaderViewHeight))
        initSubview()
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        line.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY).offset(7.5)
            make.left.equalTo(self).offset(SeparatorLeftSpacing)
            make.right.equalTo(self).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
            //            make.bottom.equalTo(0)
        }
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(11)
            make.left.equalTo(self).offset(16)
            make.bottom.equalTo(line.snp.top).offset(-11)
            make.width.equalTo(icon.snp.height)
        }
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(18)
            make.left.equalTo(icon.snp.right).offset(10)
            make.right.equalTo(state.snp.left).offset(-5)
            make.height.equalTo(15)
        }
        moneyLB.snp.makeConstraints { (make) in
            make.bottom.equalTo(line.snp.top).offset(-16)
            make.left.equalTo(titleLB)
            
            //make.right.equalTo(self.snp.centerX).offset(-50)
            make.height.equalTo(12)
        }
        state.snp.makeConstraints { (make) in
            make.top.height.equalTo(titleLB)
            make.right.equalTo(self).offset(-26)
            make.width.equalTo(100)
        }

        programmeTitle.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.left.equalTo(self).offset(26)
            make.width.equalTo(100)
            make.height.equalTo(12)
        }
        
        programmeLB.snp.makeConstraints { (make) in
            make.height.equalTo(19)
            make.left.right.width.equalTo(programmeTitle)
            make.bottom.equalTo(self).offset(-10)
        }
        
        forecastMoney.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(programmeLB.snp.right).offset(10)
            make.right.equalTo(state)
        }

//        thankLB.snp.makeConstraints { (make) in
//            make.height.equalTo(19)
//            make.right.equalTo(self).offset(-26)
//            make.left.equalTo(programmeLB.snp.right).offset(10)
//            make.bottom.equalTo(self).offset(-12)
//        }
        
        countdownBut.snp.makeConstraints { (make) in
            make.top.equalTo(state.snp.bottom).offset(6)
            make.height.equalTo(20)
            make.width.equalTo(60)
            make.right.equalTo(state)
        }
        
        countdownLB.snp.makeConstraints { (make) in
            make.centerY.equalTo(countdownBut)
            make.left.equalTo(moneyLB.snp.right).offset(10)
            make.right.equalTo(countdownBut.snp.left).offset(-6)
        }
        
        
    }
    
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        
        icon = UIImageView()
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.textColor = Color505050
        titleLB.textAlignment = .left
        //titleLB.text = "精彩足球"
        
        moneyLB = UILabel()
        moneyLB.font = Font12
        moneyLB.textColor = Color787878
        moneyLB.textAlignment = .left
        //moneyLB.text = "¥ 25.00"
        
        state = UILabel()
        state.font = Font15
        state.textColor = Color505050
        state.textAlignment = .right
        //state.text = "等待开奖"
        
        forecastMoney = UILabel()
        forecastMoney.font = Font12
        forecastMoney.textColor = ColorEA5504
        forecastMoney.textAlignment = .right
        forecastMoney.numberOfLines = 0
        
        
        line = UIView()
        line.backgroundColor = ColorE9E9E9
        
        programmeTitle = UILabel()
        programmeTitle.font = Font12
        programmeTitle.textColor = ColorA0A0A0
        programmeTitle.textAlignment = .left
        programmeTitle.text = "方案状态"
        
        programmeLB = UILabel()
        programmeLB.font = Font13
        programmeLB.textColor = Color505050
        programmeLB.textAlignment = .left
        
        
        thankLB = UILabel()
        thankLB.font = Font14
        thankLB.textColor = Color505050
        thankLB.textAlignment = .right
        
        
        countdownLB = UILabel()
        countdownLB.font = Font12
        countdownLB.textColor = Color505050
        countdownLB.textAlignment = .right
        
        
        countdownBut = UIButton(type: .custom)
        countdownBut.layer.cornerRadius = 6.0
        countdownBut.layer.borderColor = ColorD12120.cgColor
        countdownBut.layer.borderWidth = 0.5
        countdownBut.setTitle("立即支付", for: .normal)
        countdownBut.setTitleColor(.red, for: .normal)
        countdownBut.titleLabel?.font = Font12
        countdownBut.addTarget(self, action: #selector(dualPayment), for: .touchUpInside)
        
        
        
        self.addSubview(icon)
        self.addSubview(titleLB)
        self.addSubview(moneyLB)
        self.addSubview(state)
        self.addSubview(programmeTitle)
        self.addSubview(programmeLB)
        self.addSubview(line)
        self.addSubview(thankLB)
        self.addSubview(forecastMoney)
        self.addSubview(countdownLB)
        self.addSubview(countdownBut)
    }
    
    

    
    private func setWinMoney() {
        winMoney = UILabel()
        winMoney.font = Font12
        winMoney.textColor = ColorEA5504
        winMoney.textAlignment = .right
        
        
        winTitle = UILabel()
        winTitle.font = Font12
        winTitle.textColor = ColorA0A0A0
        winTitle.textAlignment = .right
        winTitle.text = "中奖金额"
        
        self.addSubview(winMoney)
        self.addSubview(winTitle)
        
        winTitle.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(5)
            make.right.equalTo(-rightSpacing)
            make.width.equalTo(100)
        }
        winMoney.snp.makeConstraints { (make) in
            make.top.equalTo(winTitle.snp.bottom).offset(1)
            make.bottom.equalTo(-5)
            make.right.equalTo(winTitle)
            make.left.equalTo(programmeTitle.snp.right).offset(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

// MARK: - 点击事件
extension OfflineOrderDetailHeaderView {
    @objc private func dualPayment() {
        delegate.didTipDualPayment()
    }
}