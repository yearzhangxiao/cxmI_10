//
//  CXMMDLTHotColdVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import XLPagerTabStrip

enum HotColdStyle : String {
    case red = "红球冷热"
    case blue = "篮球冷热"
}

class CXMMDLTHotColdVC: BaseViewController, IndicatorInfoProvider {

    public var style : HotColdStyle = .red
    
    public var redList : [DaletouDataModel]!
    public var blueList : [DaletouDataModel]!
    
    public var viewModel : DLTTrendBottomModel!
    
    public var compute: Bool! = false // 是否计算统计
    public var count: String! = "100" // 期数
    public var drop: Bool! = true     // 是否显示遗漏
    public var sort: Bool! = false    // 排序
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: DLTTrendBottom!
    
    private var list : [DLTHotOrCold]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addPanGestureRecognizer = false
        setSubview()
        loadNewData()
        setData()
        
        self.bottomView.viewModel = self.viewModel
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.bottomView.configure(red: self.redList, blue: self.blueList)
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: style.rawValue)
    }
}

extension CXMMDLTHotColdVC {
    private func setSubview() {
        self.tableView.separatorStyle = .none
        
    }
    private func setData() {
        
    }
}

// MARK: - 网络请求
extension CXMMDLTHotColdVC {
    private func loadNewData() {
        chartDataRequest()
    }
    private func chartDataRequest() {
        
        weak var weakSelf = self
        
        var tab = ""
        
        switch style {
        case .red:
            tab = "4"
        case .blue:
            tab = "5"
        }
        
        _ = dltProvider.rx.request(.chartData(compute: compute, count: count, drop: drop, sort: sort, tab : tab))
            .asObservable()
            .mapObject(type: DLTTrendModel.self)
            .subscribe(onNext: { (data) in
                switch self.style {
                case .red:
                    weakSelf?.list = data.preHeatColds
                case .blue:
                    weakSelf?.list = data.postHeatColds
                }
                
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        break
                    default : break
                    }
                    if 300000...310000 ~= code {
                        self.showHUD(message: msg!)
                    }
                    print(code)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
}

extension CXMMDLTHotColdVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension CXMMDLTHotColdVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list != nil ? list.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DLTHotColdCell", for: indexPath) as! DLTHotColdCell
        cell.configure(with: list[indexPath.row], style : self.style)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}