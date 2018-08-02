//
//  DaletouConfirmViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CXMMDaletouConfirmVC: BaseViewController {

    public var dataList : [[DaletouDataModel]] = [[DaletouDataModel]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.reloadData()
    }

   

}

extension CXMMDaletouConfirmVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMDaletouConfirmVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouConfirmCell", for: indexPath) as! DaletouConfirmCell
        cell.configure(with: dataList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        let list = dataList[indexPath.row]
        
        let count : Int = list.count / 8
        
        if count == 0 {
            return 90
        }else {
            let num : Int = dataList.count % 8
            if num == 0 {
                return CGFloat(70 + 30 * count)
            }else {
                return CGFloat(70 + 30 * (count + 1))
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 5
        default:
            return 3
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}