//
//  DaletouDanBlueCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol DaletouDanBlueCellDelegate {
    func didSelect(cell: DaletouDanBlueCell, model : DaletouDataModel, indexPath : IndexPath) -> Void
}

class DaletouDanBlueCell: UITableViewCell {

    static var cellHeight : CGFloat =  DaletouItem.width * 2 + 15 * 2 + 50
    static var omCellHeight : CGFloat = (DaletouItem.width * 2) + (21 * 3) + 50
    
    public var delegate : DaletouDanBlueCellDelegate!
    
    @IBOutlet weak var blueView: DaletouCollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubview()
    }

    private func setSubview() {
        blueView.delegate = self
        //blueView.configure(with: DaletouDataModel.getData(ballStyle: .blue))
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension DaletouDanBlueCell : DaletouCollectionViewDelegate {
    func didSelected(view: DaletouCollectionView, model: DaletouDataModel, indexPath : IndexPath) {
        guard delegate != nil else { fatalError("delegate为空")}
        delegate.didSelect(cell: self, model: model, indexPath: indexPath)
    }
}
extension DaletouDanBlueCell {
    public func configure(with list : [DaletouDataModel]) {
        blueView.configure(with: list)
    }
    public func configure(with display : DLTDisplayStyle) {
        blueView.configure(with: display)
    }
}
