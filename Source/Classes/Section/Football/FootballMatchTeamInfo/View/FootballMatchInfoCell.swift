//
//  FootballMatchInfoCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballMatchInfoCell: UITableViewCell {

    // MARK: - 属性 public
    
    public var homeMatch : String!
    public var visiMatch : String!
    
    public var teamInfo : TeamInfo! {
        didSet{
            guard teamInfo != nil else { return }
            matchName.text = teamInfo.leagueAddr
            matchTime.text = teamInfo.matchDay
            //matchScore.text = "\(teamInfo.homeTeamAbbr!)  \(teamInfo.whole!)  \(teamInfo.visitingTeamAbbr!)"
            
            //let muAtt = NSMutableAttributedString(string: "")
            
            var homeColor : UIColor = Color9F9F9F
            var visiColor : UIColor = Color9F9F9F
            var wholeColor: UIColor = Color9F9F9F
            
            guard teamInfo.matchRs != "" else { return }
            matchResult.text = teamInfo.matchRs
            if teamInfo.matchRs == "胜" {
                matchResult.textColor = ColorE85504
                wholeColor = ColorEA5504
            }else if teamInfo.matchRs == "平" {
                matchResult.textColor = Color65AADD
                wholeColor = Color65AADD
            }else{
                matchResult.textColor = Color44AE35
                wholeColor = Color44AE35
            }
            
            
            switch teamInfo.teamType {
            case "1":
                wholeColor = matchResult.textColor
            case "2":
                if teamInfo.homeTeamAbbr == homeMatch {
                    homeColor = matchResult.textColor
                }
                if teamInfo.visitingTeamAbbr == homeMatch {
                    visiColor = matchResult.textColor
                }
            case "3":
                
                if teamInfo.homeTeamAbbr == visiMatch {
                    homeColor = matchResult.textColor
                }
                if teamInfo.visitingTeamAbbr == visiMatch {
                    visiColor = matchResult.textColor
                }
                
            default: break
            }
            
            
//            if teamInfo.homeTeamAbbr == homeMatch || teamInfo.visitingTeamAbbr == homeMatch {
//                switch teamInfo.teamType {
//                case "1":
//                    wholeColor = matchResult.textColor
//                case "2":
//                    homeColor = matchResult.textColor
//                case "3":
//                    visiColor = matchResult.textColor
//                default: break
//                }
//            }else {
//                homeColor = Color9F9F9F
//            }
//
//            if teamInfo.visitingTeamAbbr == visiMatch || teamInfo.homeTeamAbbr == visiMatch{
//                switch teamInfo.teamType {
//                case "1":
//                    wholeColor = matchResult.textColor
//                case "2":
//                    homeColor = matchResult.textColor
//                case "3":
//                    visiColor = matchResult.textColor
//                default: break
//                }
//            }else {
//                visiColor = Color9F9F9F
//            }
            
            let homeAtt = NSAttributedString(string: "\(teamInfo.homeTeamAbbr!)", attributes: [NSAttributedString.Key.foregroundColor: homeColor])
            let wholeAtt = NSAttributedString(string: "\(teamInfo.whole!)", attributes: [NSAttributedString.Key.foregroundColor: wholeColor])
            let visiAtt = NSAttributedString(string: teamInfo.visitingTeamAbbr!, attributes: [NSAttributedString.Key.foregroundColor: visiColor])
            
//            muAtt.append(homeAtt)
//            muAtt.append(wholeAtt)
//            muAtt.append(visiAtt)
            
            //matchScore.attributedText = muAtt
            
            homeScore.attributedText = homeAtt
            matchScore.attributedText = wholeAtt
            visiScore.attributedText = visiAtt
            
            
            
        }
    }
    
   
    
    
    // MARK: - 属性 private
    private var matchName: UILabel!
    private var matchTime: UILabel!
    private var matchScore: UILabel!
    private var matchResult: UILabel!
    
    private var homeScore : UILabel!
    private var visiScore : UILabel!
    
    private var line : UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        line.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(10 * defaultScale)
            make.right.equalTo(-10 * defaultScale)
            make.height.equalTo(1)
        }
        
        matchName.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(63 * defaultScale)
        }
        matchTime.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(matchName)
            make.left.equalTo(matchName.snp.right)
            make.width.equalTo(80 * defaultScale)
        }
        matchResult.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(matchName)
            make.right.equalTo(-21 * defaultScale)
            make.width.equalTo(30 * defaultScale)
        }
        
        homeScore.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(matchName)
            make.left.equalTo(matchTime.snp.right)
            make.right.equalTo(matchScore.snp.left)
            make.width.equalTo(visiScore)
        }
        
        matchScore.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(matchName)
//            make.left.equalTo(matchTime.snp.right)
//            make.right.equalTo(matchResult.snp.left)
            make.width.equalTo(30 * defaultScale)
        }
        visiScore.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(matchName)
            make.left.equalTo(matchScore.snp.right)
            make.right.equalTo(matchResult.snp.left)
            
        }
    }
    
    private func initSubview(){
        self.selectionStyle = .none
        
        line = UIImageView()
        line.image = UIImage(named: "line")
        
        matchName = getLabel("赛事")
        matchName.sizeToFit()
        
        matchTime = getLabel("2018-88-88")
        matchTime.sizeToFit()
        
        matchScore = getLabel("阿森纳  0：1  AC米兰")
    
        homeScore = getLabel("")
        //homeScore.textAlignment = .right
        visiScore = getLabel("")
        //visiScore.textAlignment = .left
        
        matchResult = getLabel("")
        
        matchResult.sizeToFit()
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(matchName)
        self.contentView.addSubview(matchTime)
        self.contentView.addSubview(matchScore)
        self.contentView.addSubview(homeScore)
        self.contentView.addSubview(visiScore)
        self.contentView.addSubview(matchResult)
    }
    
    private func getLabel(_ title: String) -> UILabel {
        let lab = UILabel()
        lab.text = title
        lab.font = Font12
        lab.textColor = Color9F9F9F
        lab.textAlignment = .center
        return lab
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
