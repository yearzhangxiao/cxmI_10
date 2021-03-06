//
//  CXMMDaletouViewController.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import RxSwift
import AudioToolbox

enum DaletouType : String {
    case 标准选号 = "标准选号"
    case 胆拖选号 = "胆拖选号"
}

protocol CXMMDaletouViewControllerDelegate {
    func didSelected(list : DaletouDataList) -> Void
}

class CXMMDaletouViewController: BaseViewController {

    public var delegate : CXMMDaletouViewControllerDelegate!
   
    public var model : DaletouDataList? {
        didSet{
            guard let mod = model else { return }
            setDefaultData(dataModel: mod)
        }
    }
    
    private var randomModel : DaletouDataList! {
        didSet{
            guard let mod = randomModel else { return }
            setDefaultData(dataModel: mod)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: DaletouBottomView!

    @IBOutlet weak var topMenu: UIButton!
    
    public var isPush = false
    
    private var type : DaletouType = .标准选号 {
        didSet{
            
            if titleView != nil {
                titleView.setTitle(type.rawValue, for: .normal)
            }
            
            switch type {
            case .标准选号:
                settingNum.value = getStandardBetNum()
                motion(edit: true)
            case .胆拖选号:
                settingNum.value = getBettingNum()
                motion(edit: false)
            }
            
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
        }
    }
    
    private var prizeList : [DLTHistoricalData]!

    private var settingNum = Variable(0)
    
    private var selectedRedSet = Set<DaletouDataModel>()
    private var selectedBlueSet = Set<DaletouDataModel>()
    private var selectedDanRedSet = Set<DaletouDataModel>()
    private var selectedDragRedSet = Set<DaletouDataModel>()
    private var selectedDanBlueSet = Set<DaletouDataModel>()
    private var selectedDragBlueSet = Set<DaletouDataModel>()
    
    
    private var selectedList : [DaletouDataModel] = [DaletouDataModel]()
    
    private var displayStyle : DLTDisplayStyle = .defStyle
    private var menu : CXMMDaletouMenu = CXMMDaletouMenu()
    private var titleView : UIButton!
    public var titleIcon : UIImageView!
    
    private var omissionModel : DaletouOmissionModel!
   
    lazy private var redList : [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .red)
    }()
    lazy private var blueList : [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .blue)
    }()
    
    lazy private var danRedList : [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .danRed)
    }()
    lazy private var dragRedList: [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .dragRed)
    }()
    lazy private var danBlueList: [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .danBlue)
    }()
    lazy private var dragBlueList: [DaletouDataModel] = {
        return DaletouDataModel.getData(ballStyle: .dragBlue)
    }()
    
    private var menuTitle : String = "显示遗漏"
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.delegate = self
        bottomView.delegate = self
        
        if UserDefaults.standard.bool(forKey: "dantuoIsOpen") {
            setNavigationTitleView()
        }else {
            self.navigationItem.title = "标准选号"
        }
    
        setTableview()
        setSubview()
        
        setData()
        
        setDefaultData()
        loadNewData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.tableView.scrollsToTop = true
       // self.tableView.reloadData()
       // self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
    }
    
    private func setDefaultData() {
        guard let mod = self.model else { return }
        self.type = mod.type
    }

    
    private func setData() {
        
        _ = settingNum.asObservable().subscribe(onNext: { (num) in
            if num > 0 {
                let att = NSMutableAttributedString(string: "共")
                let numAtt = NSAttributedString(string: "\(num)", attributes: [NSAttributedString.Key.foregroundColor: ColorEA5504])
                let defa = NSAttributedString(string: "注 合计")
                let money = NSAttributedString(string: "\(num * 2).00", attributes: [NSAttributedString.Key.foregroundColor: ColorEA5504])
                let yuan = NSAttributedString(string: "元")
                att.append(numAtt)
                att.append(defa)
                att.append(money)
//                att.append(yuan)
                self.bottomView.titleLabel.attributedText = att
                self.bottomView.confirmBut.backgroundColor = ColorEA5504
                self.bottomView.confirmBut.isUserInteractionEnabled = true
            }else {
                let att = NSMutableAttributedString(string: "请至少选择")
                
                var red = 5
                if self.type == .胆拖选号 {
                    red = 6
                }
                
                let numAtt = NSAttributedString(string: "\(red)", attributes: [NSAttributedString.Key.foregroundColor: ColorEA5504])
                let defa = NSAttributedString(string: "个红球")
                let money = NSAttributedString(string: "2", attributes: [NSAttributedString.Key.foregroundColor: Color0081CC])
                let defa1 = NSAttributedString(string: "个蓝球")
                att.append(numAtt)
                att.append(defa)
                att.append(money)
                att.append(defa1)
                self.bottomView.titleLabel.attributedText = att
                self.bottomView.confirmBut.backgroundColor = ColorC7C7C7
                self.bottomView.confirmBut.isUserInteractionEnabled = false
            }
        }, onError: nil , onCompleted: nil , onDisposed: nil)
    }
    
    private func setSubview() {
        self.view.addSubview(menu)
    }
    
    override func back(_ sender: UIButton) {
       
        if isPush && self.model != nil {
            guard delegate != nil else { return }
            guard let mod = self.model else { return }
            
            delegate.didSelected(list: mod)
            self.popViewController()
        }else{
            self.popViewController()
        }
    }
}

// MARK: - public 机选
extension CXMMDaletouViewController : DLTRandom {
    @IBAction func randomOne(_ sender: UIButton) {
        let model = getOneRandom()
        self.randomModel = model
        self.tableView.reloadData()
    }
    public func configure(with data : [DaletouDataModel], type : DaletouType) {
        
    }
}

extension CXMMDaletouViewController : Algorithm {
    private func getStandardBetNum() -> Int {
        guard selectedRedSet.count >= 5, selectedBlueSet.count >= 2 else { return 0 }
        return standardBettingNum(m: selectedRedSet.count, n: selectedBlueSet.count)
    }
    private func getBettingNum() -> Int {
        
        guard match(danRedNum: selectedDanRedSet.count) else {
            return 0
        }
        guard match(dragRedNum: selectedDragRedSet.count) else {
            return 0
        }
        guard match(danBlueNum: selectedDanBlueSet.count) else {
            return 0
        }
        guard match(dragBlueNum: selectedDragBlueSet.count) else {
            return 0
        }
        guard selectedDanRedSet.count + selectedDragRedSet.count >= 6 else {
            return 0
        }
        return danBettingNum(a: selectedDanRedSet.count,
                             b: selectedDragRedSet.count,
                             c: selectedDanBlueSet.count,
                             d: selectedDragBlueSet.count)
    }
    

    private func match(danRedNum : Int) -> Bool {
        if danRedNum >= 1, danRedNum <= 4 {
            return true
        }else {
            return false
        }
    }
    
    private func match(dragRedNum : Int) -> Bool {
        return dragRedNum >= 2 ? true : false
    }
    
    private func match(danBlueNum: Int) -> Bool {
        return danBlueNum <= 1 ? true : false
    }
    private func match(dragBlueNum: Int) -> Bool {
        return dragBlueNum >= 2 ? true : false
    }
    
}

// MARK: - TOP Menu
extension CXMMDaletouViewController : YBPopupMenuDelegate{
    
    @IBAction func topMenuClick(_ sender: UIButton) {
        YBPopupMenu.showRely(on: sender, titles: ["走势图","玩法帮助","开奖结果","\(menuTitle)"],
                             icons: ["Trend","GameDescription","LotteryResult","Missing"],
                             menuWidth: 125, delegate: self)
    }
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        switch index {
        case 0:
//            let vc = CXMMDaletouTrendVC()
//            pushViewController(vc: vc)
              pushPagerView(pagerType: .trend)
            
        case 1:
            let web = CXMWebViewController()
            web.urlStr = getCurentBaseWebUrl() + DLTPlayHelpUrl
            pushViewController(vc: web)
            //TongJi.log(.关于我们安全保障, label: "大乐透玩法")
            break
        case 2:
            let story = UIStoryboard(name: "Surprise", bundle: nil )
            let prizeHistory = story.instantiateViewController(withIdentifier: "PrizeDigitalHistoryVC") as! CXMMPrizeDigitalHistoryVC
            prizeHistory.lotteryId = "2"
            pushViewController(vc: prizeHistory)
        case 3:
            if self.displayStyle == .defStyle {
                self.displayStyle = .omission
                menuTitle = "隐藏遗漏"
            }else if self.displayStyle == .omission {
                self.displayStyle = .defStyle
                menuTitle = "显示遗漏"
            }
            self.tableView.reloadData()
        default: break
        }
    }
}

// MARK: - 底部视图 代理
extension CXMMDaletouViewController : DaletouBottomViewDelegate {
    func didTipDelete() {
        switch type {
        case .标准选号:
            if selectedRedSet.isEmpty == false || selectedBlueSet.isEmpty == false {
                showAlert()
            }
        case .胆拖选号:
            if selectedDanRedSet.isEmpty == false ||
            selectedDragRedSet.isEmpty == false ||
            selectedDanBlueSet.isEmpty == false ||
                selectedDragBlueSet.isEmpty == false {
                showAlert()
            }
        }
    }
    
    func didTipConfirm() {
        
        guard isPush == false else {
        
            guard delegate != nil else { return }
            
            switch type {
            case .标准选号:
                let model = DaletouDataList()
                model.redList = getStandardReds()
                model.blueList = getStandardBlues()
                model.type = type
                model.getBettingNum()
                delegate.didSelected(list: model)
            case .胆拖选号:
                
                guard getBettingNum() * 2 <= 20000 else {
                    showHUD(message: "单次投注最多2万元")
                    return
                }
                
                let model = DaletouDataList()
                model.danRedList = getDanReds()
                model.dragRedList = getDragReds()
                model.danBlueList = getDanBlues()
                model.dragBlueList = getDragBlues()
                model.type = type
                model.getBettingNum()
                delegate.didSelected(list: model)
            }
            self.popViewController()
            //backDefaultData()
            return
        }
        
        let story = UIStoryboard(name: "Daletou", bundle: nil)
        
        let vc = story.instantiateViewController(withIdentifier: "DaletouConfirmVC") as! CXMMDaletouConfirmVC
        
        switch type {
        case .标准选号:
            let model = DaletouDataList()
            model.redList = getStandardReds()
            model.blueList = getStandardBlues()
            model.type = type
            model.getBettingNum()
            vc.list.append(model)
        case .胆拖选号:
            
            guard getBettingNum() * 2 <= 20000 else {
                showHUD(message: "单次投注最多2万元")
                return
            }
            
            let model = DaletouDataList()
            model.danRedList = getDanReds()
            model.dragRedList = getDragReds()
            model.danBlueList = getDanBlues()
            model.dragBlueList = getDragBlues()
            model.type = type
            model.getBettingNum()
            vc.list.append(model)
            
        }
        
        pushViewController(vc: vc)
        backDefaultData()
    }

    
    
    private func getStandardReds () -> [DaletouDataModel] {
        let arr = selectedRedSet.sorted{$0.number < $1.number}
        return arr
    }
    private func getStandardBlues()-> [DaletouDataModel] {
        let arr = selectedBlueSet.sorted{$0.number < $1.number}
        return arr
    }
    
    private func getDanReds() -> [DaletouDataModel] {
        let arr = selectedDanRedSet.sorted{ $0.number < $1.number}
        return arr
    }
    private func getDragReds() -> [DaletouDataModel] {
        let arr = selectedDragRedSet.sorted{$0.number < $1.number}
        return arr
    }
    private func getDanBlues() -> [DaletouDataModel] {
        let arr = selectedDanBlueSet.sorted{$0.number < $1.number}
        return arr
    }
    private func getDragBlues() -> [DaletouDataModel] {
        let arr = selectedDragBlueSet.sorted{$0.number < $1.number}
        return arr
    }

    private func showAlert() {
        showCXMAlert(title: "温馨提示", message: "\n确定清空所选号码吗？",
                     action: "确定", cancel: "取消") { (action) in
            switch self.type {
            case .标准选号:
                self.redList = DaletouDataModel.getData(ballStyle: .red)
                self.blueList = DaletouDataModel.getData(ballStyle: .blue)
                self.selectedRedSet.removeAll()
                self.selectedBlueSet.removeAll()
                self.tableView.reloadData()
            case .胆拖选号:
                self.danRedList = DaletouDataModel.getData(ballStyle: .danRed)
                self.dragRedList = DaletouDataModel.getData(ballStyle: .dragRed)
                self.danBlueList = DaletouDataModel.getData(ballStyle: .danBlue)
                self.dragBlueList = DaletouDataModel.getData(ballStyle: .dragBlue)
                self.selectedDanRedSet.removeAll()
                self.selectedDragRedSet.removeAll()
                self.selectedDanBlueSet.removeAll()
                self.selectedDragBlueSet.removeAll()
                self.tableView.reloadData()
            }
        }
    }
    
    private func backDefaultData () {
        guard isPush == false else { return }
        
        settingNum.value = 0
        
        //  guard model == nil else { return }
        redList = DaletouDataModel.getData(ballStyle: .red)
        
        blueList = DaletouDataModel.getData(ballStyle: .blue)
        
        danRedList = DaletouDataModel.getData(ballStyle: .danRed)
        
        dragRedList = DaletouDataModel.getData(ballStyle: .dragRed)
        
        danBlueList = DaletouDataModel.getData(ballStyle: .danBlue)
        
        dragBlueList = DaletouDataModel.getData(ballStyle: .dragBlue)
        
        selectedRedSet.removeAll()
        selectedBlueSet.removeAll()
        selectedDanRedSet.removeAll()
        selectedDragRedSet.removeAll()
        selectedDanBlueSet.removeAll()
        selectedDragBlueSet.removeAll()
        
        
        
        
        self.tableView.reloadData()
    }
}

// MARK: - PUSH
extension CXMMDaletouViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "pushConfirm":
//            let vc = segue.destination as! CXMMDaletouConfirmVC
//            
//            var arr = selectedRedSet.sorted{$0.number < $1.number}
//            arr.append(contentsOf: selectedBlueSet.sorted{$0.number < $1.number})
//            vc.dataList.insert(arr, at: 0)
//            
//        default: break
//            
//        }
    }
}

// MARK: - CELL DELEGATE
extension CXMMDaletouViewController : DaletouStandardRedCellDelegate,
                                        DaletouStandardBlueCellDelegate,
                                        DaletouDanRedCellDelegate,
                                        DaletouDanBlueCellDelegate,
                                        DaletouDragRedCellDelegate,
                                        DaletouDragBlueCellDelegate{
    // 什么是胆拖？
    func didTipHelp() {
        
    }
    
    
    func didSelect(cell: DaletouStandardRedCell, model: DaletouDataModel, indexPath : IndexPath) {
        
        model.selected = !model.selected
        insertRedData(model: model)
        
        
        guard validate(bettingNum: getStandardBetNum(), ballNum: selectedRedSet.count, selected: model.selected) else {
            model.selected = false
            insertRedData(model: model)
            return
        }
        
        settingNum.value = getStandardBetNum()
        
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    
    func didSelect(cell: DaletouStandardBlueCell, model: DaletouDataModel, indexPath : IndexPath) {
        model.selected = !model.selected
        insertBlueData(model: model)
        
        guard validate(bettingNum: getStandardBetNum(),
                       ballNum: selectedBlueSet.count,
                       selected: model.selected) else {
                        
            model.selected = false
            insertBlueData(model: model)
                        
            return
        }
        
        settingNum.value = getStandardBetNum()
        
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    // 红胆
    func didSelect(cell: DaletouDanRedCell, model: DaletouDataModel, indexPath : IndexPath) {
        selectedDragRedSet.remove(dragRedList[indexPath.row])
        
        if selectedDanRedSet.count >= 0, selectedDanRedSet.count <= 3, model.selected == false {
            model.selected = !model.selected
        }else {
            model.selected = false
        }
        insertDanRed(model: model)
        if model.selected {
            dragRedList[indexPath.row].selected = false
        }
        
        settingNum.value = getBettingNum()
        
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    func didSelect(cell: DaletouDragRedCell, model: DaletouDataModel, indexPath : IndexPath) {
        model.selected = !model.selected
        insertDragRed(model: model)
        
        if model.selected {
            danRedList[indexPath.row].selected = false
        }
        
        selectedDanRedSet.remove(danRedList[indexPath.row])
        
        settingNum.value = getBettingNum()
        
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    // 蓝胆
    func didSelect(cell: DaletouDanBlueCell, model: DaletouDataModel, indexPath : IndexPath) {
        selectedDragBlueSet.remove(dragBlueList[indexPath.row])

//        if selectedDanBlueSet.count <= 0, model.selected == false {
//            model.selected = !model.selected
//        }else {
//            model.selected = false
//        }
        model.selected = !model.selected
        // 点击的为选中，，其他已选中的要改成未选中状态
        for blue in selectedDanBlueSet {
            blue.selected = false
        }
        selectedDanBlueSet.removeAll()
        
        insertDanBlue(model: model)
        if model.selected {
            dragBlueList[indexPath.row].selected = false
        }
        
        settingNum.value = getBettingNum()
        
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    func didSelect(cell: DaletouDragBlueCell, model: DaletouDataModel, indexPath : IndexPath) {
        selectedDanBlueSet.remove(danBlueList[indexPath.row])
        model.selected = !model.selected
        insertDragBlue(model: model)
        if model.selected {
            danBlueList[indexPath.row].selected = false
        }
        
        settingNum.value = getBettingNum()
        
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    
    
    private func insertRedData(model: DaletouDataModel) {
        switch model.selected {
        case true:
            selectedRedSet.insert(model)
        case false:
            selectedRedSet.remove(model)
        }
    }
    private func insertBlueData(model: DaletouDataModel) {
        switch model.selected {
        case true:
            selectedBlueSet.insert(model)
        case false:
            selectedBlueSet.remove(model)
        }
    }
    private func insertDanRed(model: DaletouDataModel) {
        switch model.selected {
        case true:
            selectedDanRedSet.insert(model)
           
        case false:
            selectedDanRedSet.remove(model)
            
        }
    }
    private func insertDragRed (model: DaletouDataModel) {
        switch model.selected {
        case true:
            selectedDragRedSet.insert(model)
           
        case false:
            selectedDragRedSet.remove(model)
            
        }
    }
    private func insertDanBlue(model: DaletouDataModel) {
        switch model.selected {
        case true:
            selectedDanBlueSet.insert(model)
            
        case false:
            selectedDanBlueSet.remove(model)
           
        }
    }
    private func insertDragBlue(model: DaletouDataModel) {
        switch model.selected {
        case true:
            selectedDragBlueSet.insert(model)
            
        case false:
            selectedDragBlueSet.remove(model)
            
        }
    }
    
    private func validate (bettingNum : Int, ballNum: Int, selected : Bool, isdan : Bool = false) -> Bool {
        switch selected {
        case false:
            return true
        case true:
            if isdan == false {
                guard selectedRedSet.count <= 18 else {
                    showHUD(message: "最多只能选择18个红球")
                    return false
                }
            }
            
            guard bettingNum * 2 <= 20000 else {
                showHUD(message: "单次投注最多2万元")
                return false
            }
            return true
        }
    }
    
}

extension CXMMDaletouViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch type {
        case .标准选号:
            switch indexPath.row {
            case 0:
                let history = CXMMDaletouHistoryAward()
                history.prizeList = self.prizeList
                present(history)
            default: break
            }
        case .胆拖选号:
            switch indexPath.row {
            case 0:
                let history = CXMMDaletouHistoryAward()
                history.prizeList = self.prizeList
                present(history)
            case 1:
                let web = CXMWebViewController()
                web.urlStr = getCurentBaseWebUrl() + DLTDanHelpUrl
                pushViewController(vc: web)
            default : break
            }
            break
        }
    }
}
// MARK: - 导航栏 title MENU
extension CXMMDaletouViewController : CXMMDaletouMenuDelegate {
    
    func didTipMenu(view: CXMMDaletouMenu, type: DaletouType) {
        titleIcon.image = UIImage(named: "Down")
        guard UserDefaults.standard.bool(forKey: "dantuoIsOpen") else {
            if type == .胆拖选号 {
                showHUD(message: "敬请期待")
            }
            return
        }
        self.type = type
        
    }
    func didCancel() {
        titleIcon.image = UIImage(named: "Down")
    }
    private func setNavigationTitleView() {
        titleView = UIButton(type: .custom)
        
        titleView.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        titleView.titleLabel?.font = Font17
        titleView.setTitle(type.rawValue, for: .normal)
        titleView.setTitleColor(ColorNavItem, for: .normal)
       
        titleView.addTarget(self, action: #selector(titleViewClicked(_:)), for: .touchUpInside)

        self.navigationItem.titleView = titleView
        
        titleIcon = UIImageView(image: UIImage(named: "Down"))
        
        titleView.addSubview(titleIcon)
        
        titleIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(12)
            make.right.equalTo(14)
            make.centerY.equalTo(titleView.snp.centerY)
        }
    }
    
    @objc private func titleViewClicked(_ sender: UIButton) {
        
        guard UserDefaults.standard.bool(forKey: "dantuoIsOpen") else {
            return
        }
        showMatchMenu()
        titleIcon.image = UIImage(named: "Upon")
    }
    
    private func showMatchMenu() {
        menu.configure(with: type)
        menu.show()
    }
   
}

// MARK: - 摇一摇
extension CXMMDaletouViewController {
    private func motion(edit: Bool) {
        UIApplication.shared.applicationSupportsShakeToEdit = edit
        self.becomeFirstResponder()
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        switch type {
        case .标准选号:
            let model = getOneRandom()
            self.model = model
            self.tableView.reloadData()
            let soundID = SystemSoundID(kSystemSoundID_Vibrate)
            //振动
            AudioServicesPlaySystemSound(soundID)
            
        case .胆拖选号:
            break
        }
    }
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
    }
    
}

// MARK: - 网络请求
extension CXMMDaletouViewController {
    private func loadNewData() {
        ticketInfoRequest()
    }
    
    private func ticketInfoRequest() {
        weak var weakSelf = self
        _ = dltProvider.rx.request(.tickenInfo)
            .asObservable()
            .mapObject(type: DaletouOmissionModel.self)
            .subscribe(onNext: { (data) in
                self.omissionModel = data
            
                UserDefaults.standard.set(data.isShowDragOn, forKey: "dantuoIsOpen")
                
                self.prizeList = data.prizeList
                for i in 0..<self.redList.count {
                    self.redList[i].omissionNum = self.omissionModel.preList[i]
                }
                for i in 0..<self.blueList.count {
                    self.blueList[i].omissionNum = self.omissionModel.postList[i]
                }
                for i in 0..<self.danRedList.count {
                    self.danRedList[i].omissionNum = self.omissionModel.preList[i]
                }
                for i in 0..<self.dragRedList.count {
                    self.dragRedList[i].omissionNum = self.omissionModel.preList[i]
                }
                for i in 0..<self.danBlueList.count {
                    self.danBlueList[i].omissionNum = self.omissionModel.postList[i]
                }
                for i in 0..<self.dragBlueList.count {
                    self.dragBlueList[i].omissionNum = self.omissionModel.postList[i]
                }
                
                self.tableView.reloadData()
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    if 300000...310000 ~= code {
                        self.showHUD(message: msg!)
                    }
                    print(code)
                default: break
                }
            }, onCompleted: nil , onDisposed: nil)
    }
}

extension CXMMDaletouViewController {
    private func setTableview() {
        if #available(iOS 11.0, *) {
            
        }else {
            tableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 49, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }
}
extension CXMMDaletouViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .标准选号:
            return 3
        case .胆拖选号:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch type {
        case .标准选号:
            switch indexPath.row {
            case 0:
                return initTitleCell(tableView, indexPath)
            case 1:
                return initStandardRedCell(tableView, indexPath)
            case 2:
                return initStandardBlueCell(tableView, indexPath)
            default:
                return UITableViewCell()
            }
        case .胆拖选号:
            switch indexPath.row {
            case 0:
                return initTitleCell(tableView, indexPath)
            case 1:
                return initDanRedCell(tableView, indexPath)
            case 2:
                return initDragRedCell(tableView, indexPath)
            case 3:
                return initDanBlueCell(tableView, indexPath)
            case 4:
                return initDragBlueCell(tableView, indexPath)
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch type {
        case .标准选号:
            switch indexPath.row {
            case 0:
                return 40
            case 1:
                switch displayStyle {
                case .defStyle:
                    return DaletouStandardRedCell.cellHeight
                case .omission:
                    return DaletouStandardRedCell.omCellHeight
                }
            case 2:
                switch displayStyle {
                case .defStyle:
                    return DaletouStandardBlueCell.cellHeight
                case .omission:
                    return DaletouStandardBlueCell.omCellHeight
                }
            default:
                return 0
            }
        case .胆拖选号:
            switch indexPath.row {
            case 0:
                return 40
            case 1:
                switch displayStyle {
                case .defStyle:
                    return DaletouDanRedCell.cellHeight
                case .omission:
                    return DaletouDanRedCell.omCellHeight
                }
            case 2:
                switch displayStyle {
                case .defStyle:
                    return DaletouDragRedCell.cellHeight
                case .omission:
                    return DaletouDragRedCell.omCellHeight
                }
            case 3:
                switch displayStyle {
                case .defStyle:
                    return DaletouDanBlueCell.cellHeight
                case .omission:
                    return DaletouDanBlueCell.omCellHeight
                }
            case 4:
                switch displayStyle {
                case .defStyle:
                    return DaletouDragBlueCell.cellHeight
                case .omission:
                    return DaletouDragBlueCell.omCellHeight
                }
            default:
                return 0
            }
        }
    }
    
    private func initTitleCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouTitleCell", for: indexPath) as! DaletouTitleCell
        if self.omissionModel != nil {
            cell.configure(model: self.omissionModel)
        }
        return cell
    }
    
    private func initStandardRedCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouStandardRedCell", for: indexPath) as! DaletouStandardRedCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        cell.configure(with: redList)
        if self.omissionModel != nil {
            cell.configure(model: self.omissionModel, display: self.displayStyle)
        }
        return cell
    }
    private func initStandardBlueCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouStandardBlueCell", for: indexPath) as! DaletouStandardBlueCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        cell.configure(with: blueList)
        return cell
    }
    private func initDanRedCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouDanRedCell", for: indexPath) as! DaletouDanRedCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        cell.configure(with: danRedList)
        if self.omissionModel != nil {
            cell.configure(model: self.omissionModel, display: self.displayStyle)
        }
        return cell
    }
    private func initDragRedCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouDragRedCell", for: indexPath) as! DaletouDragRedCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        cell.configure(with: dragRedList)
        return cell
    }
    private func initDanBlueCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouDanBlueCell", for: indexPath) as! DaletouDanBlueCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        cell.configure(with: danBlueList)
        return cell
    }
    private func initDragBlueCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaletouDragBlueCell", for: indexPath) as! DaletouDragBlueCell
        cell.delegate = self
        cell.configure(with: self.displayStyle)
        cell.configure(with: dragBlueList)
        return cell
    }
}

extension CXMMDaletouViewController {
    private func setDefaultData( dataModel : DaletouDataList) {
        
        switch dataModel.type {
        case .标准选号:
            self.selectedRedSet.removeAll()
            self.selectedBlueSet.removeAll()
            for data in self.redList {
                data.selected = false
            }
            for data in self.blueList {
                data.selected = false
            }
            
            for data in dataModel.redList {
                for data1 in self.redList {
                    if data.num == data1.num {
                        data1.selected = data.selected
                        self.selectedRedSet.insert(data1)
                        break
                    }
                }
            }
            for data in dataModel.blueList {
                for data1 in self.blueList {
                    if data.num == data1.num {
                        data1.selected = data.selected
                        self.selectedBlueSet.insert(data1)
                        break
                    }
                }
            }
            settingNum.value = getStandardBetNum()
        case .胆拖选号:
            self.selectedDanRedSet.removeAll()
            self.selectedDragRedSet.removeAll()
            self.selectedDanBlueSet.removeAll()
            self.selectedDragBlueSet.removeAll()
            for data in dataModel.danRedList {
                for data1 in self.danRedList {
                    if data.num == data1.num {
                        data1.selected = data.selected
                        self.selectedDanRedSet.insert(data1)
                        break
                    }
                }
            }
            for data in dataModel.dragRedList {
                for data1 in self.dragRedList {
                    if data.num == data1.num {
                        data1.selected = data.selected
                        self.selectedDragRedSet.insert(data1)
                        break
                    }
                }
            }
            for data in dataModel.danBlueList {
                for data1 in self.danBlueList {
                    if data.num == data1.num {
                        data1.selected = data.selected
                        self.selectedDanBlueSet.insert(data1)
                        break
                    }
                }
            }
            for data in dataModel.dragBlueList {
                for data1 in self.dragBlueList {
                    if data.num == data1.num {
                        data1.selected = data.selected
                        self.selectedDragBlueSet.insert(data1)
                        break
                    }
                }
            }
            settingNum.value = getBettingNum()
        }
    }
}

