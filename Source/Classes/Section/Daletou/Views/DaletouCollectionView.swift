//
//  DaletouCollectionView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum BallStyle {
    case red
    case blue
}

class DaletouCollectionView: UIView {

    private var ballStyle : BallStyle = .red
    
    private var dataList : [DaletouDataModel]!
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

}

// MARK: - 数据
extension DaletouCollectionView {
    public func configure(with dataList: [DaletouDataModel]) {
        self.dataList = dataList
        self.collectionView.reloadData()
    }
    // 隐藏数据
    public func configure(with omissionList : [Any]) {
        
    }
}

extension DaletouCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataList[indexPath.row]
        model.selected = !model.selected
        collectionView.reloadData()
    }
}

extension DaletouCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.dataList != nil else { return 0 }
        return self.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaletouItem", for: indexPath) as! DaletouItem
        cell.configure(with: self.dataList[indexPath.row])
        return cell
    }
    
    
}

extension DaletouCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DaletouItem.width, height: DaletouItem.heiht)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 15, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return ((screenWidth - 32 - (36 * 7)) / 6) - 1
    }
}
