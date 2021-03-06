//
//  LeagueMatchFilterItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class LeagueMatchFilterItem: UICollectionViewCell {
    
    static let width : CGFloat = (screenWidth - 40 - 40) / 3 - 1
    static let height: CGFloat = 30
    
    static let identifier = "LeagueMatchFilterItem"
    
    private var title : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubview()
    }
    
    private func initSubview() {
        title = UILabel()
        title.font = Font13
        title.textColor = Color505050
        title.textAlignment = .center
        title.text = "西班牙杯"
        title.layer.cornerRadius = 2
        title.layer.masksToBounds = true
        title.layer.borderWidth = 1
        title.layer.borderColor = ColorE9E9E9.cgColor
        self.contentView.addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LeagueMatchFilterItem {
    public func configure(with data : LeagueInfoModel) {
        title.text = data.leagueAddr
    }
}

