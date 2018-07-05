//
//  FootballMatchInfoVC.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let FootballAnalysisSectionHeaderId = "FootballAnalysisSectionHeaderId"
fileprivate let FootballMatchInfoCellId = "FootballMatchInfoCellId"
fileprivate let FootballMatchInfoScaleCellId = "FootballMatchInfoScaleCellId"
fileprivate let FootballMatchIntegralCellId = "FootballMatchIntegralCellId"
fileprivate let FootballOddsTitleCellId = "FootballOddsTitleCellId"
fileprivate let FootballOddsCellId = "FootballOddsCellId"

enum TeamInfoStyle {
    case matchDetail //赛况
    case analysis  //分析
    case odds      //赔率
    case lineup    //阵容
}

class FootballMatchInfoVC: BaseViewController, UITableViewDelegate {
    
    public var matchId : String!
    
    // MARK: - 属性 private
    private var teamInfoStyle : TeamInfoStyle = .matchDetail {
        didSet{
            self.tableView.reloadData()
        }
    }
    private var oddsStyle : OddsPagerStyle! = .欧赔 {
        didSet{
            self.tableView.reloadData()
        }
    }
    var matchInfoModel: FootballMatchInfoModel! {
        didSet{
            guard matchInfoModel != nil else { return }
            headerView.matchInfo = self.matchInfoModel.matchInfo
        }
    }
    private var headerView : FootballMatchInfoHeader!
    private var buyButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 查看详情"
        initSubview()
        
        matchInfoRequest(matchId: matchId)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TongJi.start("赛事分析页/赔率页")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TongJi.end("赛事分析页/赔率页")
    }
    // MARK: - 去投注
    @objc private func buyButtonClicked(_ sender: UIButton) {
        popToRootViewController()
        self.tabBarController?.selectedIndex = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            //make.bottom.equalTo(buyButton.snp.top)
            make.bottom.equalTo(-SafeAreaBottomHeight)
        }
        // 暂时隐藏
//        buyButton.snp.makeConstraints { (make) in
//            make.bottom.equalTo(-SafeAreaBottomHeight)
//            make.height.equalTo(36 * defaultScale)
//            make.left.right.equalTo(0)
//        }
    }
    // MARK: - 网络请求
    func matchInfoRequest(matchId: String) {
        self.showProgressHUD()
        weak var weakSelf = self
        
        _ = homeProvider.rx.request(.matchTeamInfo(matchId: matchId))
            .asObservable()
            .mapObject(type: FootballMatchInfoModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                weakSelf?.matchInfoModel = data
                weakSelf?.tableView.reloadData()
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    
    private func initSubview() {
        buyButton = UIButton(type: .custom)
        buyButton.setTitle("去投注", for: .normal)
        buyButton.setTitleColor(ColorFFFFFF, for: .normal)
        buyButton.backgroundColor = ColorEA5504
        buyButton.addTarget(self, action: #selector(buyButtonClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(tableView)
        //self.view.addSubview(buyButton)
    }
    
    //MARK: - 懒加载
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = ColorF4F4F4
        table.separatorStyle = .none
        table.register(FootballMatchInfoCell.self, forCellReuseIdentifier: FootballMatchInfoCellId)
        table.register(FootballMatchInfoScaleCell.self, forCellReuseIdentifier: FootballMatchInfoScaleCellId)
        table.register(FootballMatchIntegralCell.self, forCellReuseIdentifier: FootballMatchIntegralCellId)
        table.register(FootballOddsTitleCell.self, forCellReuseIdentifier: FootballOddsTitleCellId)
        table.register(FootballOddsCell.self, forCellReuseIdentifier: FootballOddsCellId)
        table.register(FootballAnalysisSectionHeader.self, forHeaderFooterViewReuseIdentifier: FootballAnalysisSectionHeaderId)
        table.register(FootballDetailSectionHeader.self, forHeaderFooterViewReuseIdentifier: FootballDetailSectionHeader.identifier)
        table.register(FootballDetailEventCell.self, forCellReuseIdentifier: FootballDetailEventCell.identifier)
        table.register(FootballDetailEventExplainCell.self, forCellReuseIdentifier: FootballDetailEventExplainCell.identifier)
        headerView = FootballMatchInfoHeader()
        headerView.pagerView.delegate = self
        
        table.tableHeaderView = headerView
     
        return table
    }()
    
    
}

// MARK: -  pagerView delegate
extension FootballMatchInfoVC : FootballMatchPagerViewDelegate {
    func didSelected(_ teamInfoStyle: TeamInfoStyle) {
        self.teamInfoStyle = teamInfoStyle
    }
}

extension FootballMatchInfoVC : FootballOddsPagerViewDelegate {
    // MARK: - 赔率 pagerView delegate
    func didSelected(_ oddsStyle: OddsPagerStyle) {
        self.oddsStyle = oddsStyle
    }
}

extension FootballMatchInfoVC : UITableViewDataSource {
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch teamInfoStyle {
        case .odds:
            return 1
        case .analysis:
            return 5
        case .matchDetail:
            return 3
        case .lineup :
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.matchInfoModel != nil else { return 0 }
        
        switch teamInfoStyle {
        case .odds:
            switch oddsStyle {
            case .欧赔:
                guard self.matchInfoModel.leagueMatchEuropes.isEmpty == false else { return 1 }
                return self.matchInfoModel.leagueMatchEuropes.count + 1
            case .亚盘:
                guard self.matchInfoModel.leagueMatchAsias.isEmpty == false else { return 1 }
                return self.matchInfoModel.leagueMatchAsias.count + 1
            case .大小球:
                guard self.matchInfoModel.leagueMatchDaoxiaos.isEmpty == false else { return 1 }
                return self.matchInfoModel.leagueMatchDaoxiaos.count + 1
            default : return 1
            }
        case .analysis:
            switch section {
            case 0:
                return 1
            case 1:
                guard self.matchInfoModel.hvMatchTeamInfo.matchInfos != nil else { return 0 }
                return self.matchInfoModel.hvMatchTeamInfo.matchInfos.count
            case 2:
                guard self.matchInfoModel.hMatchTeamInfo.matchInfos != nil else { return 0 }
                return self.matchInfoModel.hMatchTeamInfo.matchInfos.count
            case 3:
                guard self.matchInfoModel.vMatchTeamInfo.matchInfos != nil else { return 0 }
                return self.matchInfoModel.vMatchTeamInfo.matchInfos.count
            case 4:
                return 0 // 暂时隐藏 积分排名，如需打开  return 1
            default:
                return 0
            }
        case .matchDetail:
            return 6
        case .lineup:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch teamInfoStyle {
        case .odds:
            switch indexPath.row {
            case 0:
                return initOddsTitleCell(indexPath: indexPath)
            default:
                return initOddsCell(indexPath: indexPath)
            }
        case .analysis:
            switch indexPath.section {
            case 0:
                return initAnalysisScaleCell(indexPath: indexPath)
            case 1, 2, 3:
                return initAnalysisMatchInfoCell(indexPath: indexPath)
            case 4:
                return initAnalysisIntegralCell(indexPath: indexPath)
            default:
                return UITableViewCell()
            }
        case .matchDetail:
            if indexPath.row == 5 {
                return initMatchDetailEventExplain(indexPath: indexPath)
            }
            if indexPath.row == 0 {
                return initMatchDetailEventCell(indexPath: indexPath)
            }else {
                return initMatchDetailEventCell(indexPath: indexPath)
            }
        case .lineup:
            return UITableViewCell()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard self.matchInfoModel != nil else { return UIView() }
        
        switch teamInfoStyle {
        case .odds:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballAnalysisSectionHeaderId) as! FootballAnalysisSectionHeader
            
            switch section {
                //            case 0:
                //                header.headerStyle = .标题
            //                header.teamInfo = self.matchInfoModel.hvMatchTeamInfo
            case 1:
                header.headerStyle = .赛事
                
            case 2:
                header.headerStyle = .主队
                header.teamInfo = self.matchInfoModel.hMatchTeamInfo
            case 3:
                header.headerStyle = .客队
                header.teamInfo = self.matchInfoModel.vMatchTeamInfo
            case 4:
                return UIView()
            default:
                return UIView()
                
            }
            
            return header
        case .analysis:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballAnalysisSectionHeaderId) as! FootballAnalysisSectionHeader
            
            switch section {
            case 0:
                header.headerStyle = .标题
                header.teamInfo = self.matchInfoModel.hvMatchTeamInfo
            case 1:
                header.headerStyle = .赛事
                
            case 2:
                header.headerStyle = .主队
                header.teamInfo = self.matchInfoModel.hMatchTeamInfo
            case 3:
                header.headerStyle = .客队
                header.teamInfo = self.matchInfoModel.vMatchTeamInfo
            case 4:
                return UIView()
            default:
                break
                
            }
            return header
        case .matchDetail:

            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballDetailSectionHeader.identifier) as! FootballDetailSectionHeader
            header.titleLabel.text = "事件"
            return header
            
        case .lineup:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FootballDetailSectionHeader.identifier) as! FootballDetailSectionHeader
            header.titleLabel.text = "事件"
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch teamInfoStyle {
        case .odds:
            switch indexPath.row {
            case 0:
                return 72 * defaultScale
            default:
                return 50 * defaultScale
            }
        case .analysis:
            switch indexPath.section {
            case 0:
                return 96 * defaultScale
            case 1, 2, 3:
                return 42 * defaultScale
            case 4:
                return 375 * defaultScale
            default:
                return 0
            }
        case .matchDetail:
            if indexPath.row == 5 {
                return 70 * defaultScale
            }
            return 50 * defaultScale
        case .lineup:
            return 50 * defaultScale
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch teamInfoStyle {
        case .odds:
            return 0
        case .analysis:
            switch section {
            case 0:
                return 44 * defaultScale
            case 1:
                return 44 * defaultScale
            case 2, 3:
                return 80 * defaultScale
            case 4:
                return 0.01
            default:
                return 0
            }
        case .matchDetail:
            return 44 * defaultScale
        case .lineup:
            return 44 * defaultScale
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    /// 赛况 - 事件信息
    private func initMatchDetailEventCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballDetailEventCell.identifier, for: indexPath) as! FootballDetailEventCell
        cell.score = "2:0"
        if indexPath.row == 0 {
            cell.hiddenStart = false
            cell.hiddenTop = true
        }else{
            cell.hiddenTop = false
            cell.hiddenStart = true
        }
        
        if indexPath.row == 4 {
            cell.hiddenBot = true
        }else {
            cell.hiddenBot = false
        }
        
        return cell
    }
    /// 赛况 - 说明
    private func initMatchDetailEventExplain(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballDetailEventExplainCell.identifier, for: indexPath) as! FootballDetailEventExplainCell
        return cell
    }
    /// 赛况 - 技术统计
    private func initMatchDetailStatisticsCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballDetailEventCell.identifier, for: indexPath) as! FootballDetailEventCell
        
        return cell
    }
    /// 分析 统计 历史交锋 Cell
    private func initAnalysisScaleCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballMatchInfoScaleCellId, for: indexPath) as! FootballMatchInfoScaleCell
        cell.teamInfo = self.matchInfoModel.hvMatchTeamInfo
        return cell
    }
    /// 分析  Cell
    private func initAnalysisMatchInfoCell(indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballMatchInfoCellId, for: indexPath) as! FootballMatchInfoCell
        cell.homeMatch = self.matchInfoModel.matchInfo.homeTeamAbbr
        cell.visiMatch = self.matchInfoModel.matchInfo.visitingTeamAbbr
        switch indexPath.section {
        case 1:
            var teamInfo = self.matchInfoModel.hvMatchTeamInfo.matchInfos[indexPath.row]
            teamInfo.teamType = "1"
            cell.teamInfo = teamInfo
        case 2:
            var teamInfo = self.matchInfoModel.hMatchTeamInfo.matchInfos[indexPath.row]
            teamInfo.teamType = "2"
            cell.teamInfo = teamInfo
        case 3:
            var teamInfo = self.matchInfoModel.vMatchTeamInfo.matchInfos[indexPath.row]
            teamInfo.teamType = "3"
            cell.teamInfo = teamInfo
        default:
            break
        }
        return cell
    }
    /// 分析 积分 Cell
    private func initAnalysisIntegralCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballMatchIntegralCellId, for: indexPath) as! FootballMatchIntegralCell
        cell.homeScoreInfo = self.matchInfoModel.homeTeamScoreInfo
        cell.visiScoreInfo = self.matchInfoModel.visitingTeamScoreInfo
        return cell
    }
    /// 赔率 title Cell
    private func initOddsTitleCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOddsTitleCellId, for: indexPath) as! FootballOddsTitleCell
        cell.pagerView.delegate = self
        switch oddsStyle {
        case .欧赔:
            cell.titleView.homelb.text = "胜"
            cell.titleView.flatlb.text = "平"
            cell.titleView.visilb.text = "负"
        case .亚盘:
            cell.titleView.homelb.text = "主"
            cell.titleView.flatlb.text = "盘口"
            cell.titleView.visilb.text = "负"
        case .大小球:
            cell.titleView.homelb.text = "大"
            cell.titleView.flatlb.text = "盘口"
            cell.titleView.visilb.text = "小"
        default : break
            
        }
        return cell
    }
    /// 赔率  Cell
    private func initOddsCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FootballOddsCellId, for: indexPath) as! FootballOddsCell
        switch oddsStyle {
        case .欧赔:
            cell.europeInfo = self.matchInfoModel.leagueMatchEuropes[indexPath.row - 1]
        case .亚盘:
            cell.asiaInfo = self.matchInfoModel.leagueMatchAsias[indexPath.row - 1]
        case .大小球:
            cell.daxiaoInfo = self.matchInfoModel.leagueMatchDaoxiaos[indexPath.row - 1]
        default : break
        }
        return cell
    }
}

