//
//  FootballLineupViewCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//  偶数

import UIKit

fileprivate let spacing : CGFloat = 50

class FootballLineupViewCell: UITableViewCell {

    static let identifier = "FootballLineupViewCell"
    
    public var lineupList : [FootballLineupMemberInfo]! {
        didSet{
            if lineupType == .主队 {
                setHomeData()
            }else {
                setVisiData()
            }
        }
    }
    
    private func setHomeData () {
        for lineup in lineupList {
            switch lineup.positionY {
            case MemberYType.CL.rawValue :
                crIcon.memberInfo = lineup
                crIcon.image = "Hometeam_1"
            case MemberYType.CR.rawValue :
                clIcon.memberInfo = lineup
                clIcon.image = "Hometeam_1"
            case MemberYType.R.rawValue :
                lIcon.memberInfo = lineup
                lIcon.image = "Hometeam_1"
            case MemberYType.L.rawValue :
                rIcon.memberInfo = lineup
                rIcon.image = "Hometeam_1"
            default : break
            }
        }
    }
    private func setVisiData () {
        for lineup in lineupList {
            switch lineup.positionY {
            case MemberYType.CL.rawValue :
                clIcon.memberInfo = lineup
                clIcon.image = "Visitingteam_1"
            case MemberYType.CR.rawValue :
                crIcon.memberInfo = lineup
                crIcon.image = "Visitingteam_1"
            case MemberYType.R.rawValue :
                rIcon.memberInfo = lineup
                rIcon.image = "Visitingteam_1"
            case MemberYType.L.rawValue :
                lIcon.memberInfo = lineup
                lIcon.image = "Visitingteam_1"
            default : break
            }
        }
    }
    
    public var lineupType : LineupType!
    
    private var clIcon: FootballLineupMemView! // 左中
    private var crIcon: FootballLineupMemView! // 右中
    private var lIcon : FootballLineupMemView! // 左
    private var rIcon : FootballLineupMemView! // 右
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        initSubview()
    }
    
    private func initSubview() {
        clIcon = FootballLineupMemView()
        crIcon = FootballLineupMemView()
        lIcon = FootballLineupMemView()
        rIcon = FootballLineupMemView()
        
        self.contentView.addSubview(clIcon)
        self.contentView.addSubview(crIcon)
        self.contentView.addSubview(lIcon)
        self.contentView.addSubview(rIcon)
        
        lIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.height.equalTo(48)
            make.left.equalTo(0)
        }
        clIcon.snp.makeConstraints { (make) in
            make.centerY.width.height.equalTo(lIcon)
            make.left.equalTo(lIcon.snp.right)
        }
        crIcon.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(lIcon)
            make.left.equalTo(clIcon.snp.right)
        }
        rIcon.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(crIcon)
            make.left.equalTo(crIcon.snp.right)
            make.right.equalTo(-0)
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
