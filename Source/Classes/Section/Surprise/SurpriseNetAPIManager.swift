//
//  SurpriseNetAPIManager.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Moya
import RxSwift



let surpriseProvider = MoyaProvider<SurpriseAPIManager>(requestClosure: requestClosure,plugins:[RequestLoadingPlugin()])


enum SurpriseAPIManager {
    /// 发现首页列表
    case surpriseList()
    /// 开奖结果
    case prizeList()
    /// 活动中心
    case activityCenter()
    /// 联赛信息 首页
    case leagueList(groupId: String)
    /// 联赛详情
    case leagueDetail(leagueId : String, seasonId : String)
    /// 历史开奖
    case lottoPrizeList(page : Int, lotteryId : String)
    /// 竞彩历史开奖
    case matchPrizeList(date : String, lotteryId : String)
    /// 开奖详情  （期号）
    case lottoPrizeDetail(termNum : String, lotteryId : String)
    /// 小白课堂
    case schoolList
    /// 球队详情
    case teamDetail(teamId : String)
    /// 服务列表
    case serviceList
    /// 发现更多
    case surpriseMoreList
}

extension SurpriseAPIManager : TargetType {
    
    var baseURL : URL {
        let url = platformBaseUrl()
        return URL(string : url! + xpath )!
    }
    var path : String { return ""}
    
    var xpath : String {
        switch self {
        case .surpriseList:
            return "/lottery/discoveryPage/homePage"
        case .prizeList:
            return "/lottery/discoveryPage/openPrize"
        case .activityCenter:
            return "/lottery/discoveryPage/activeCenter"
        case .leagueList:
            return "/lottery/discoveryPage/leagueHomePageByGroupId"
        case .leagueDetail:
            return "/lottery/discoveryPage/leagueDetailForDiscovery"
        case .lottoPrizeList:
            return "/lottery/discoveryPage/szcDetailList"
        case .lottoPrizeDetail:
            return "/lottery/discoveryPage/querySzcOpenPrizesByDate"
        case .schoolList:
            return "/lottery/discoveryPage/noviceClassroom"
        case .matchPrizeList:
            return "/lottery/discoveryPage/queryJcOpenPrizesByDate"
        case .teamDetail:
            return "/lottery/discoveryPage/teamDetailForDiscovery"
        case .serviceList:
            return "/order/serv/servlist"
        case .surpriseMoreList:
            return "/lottery/lottery/hall/moreDiscoveryClass"
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        switch self {
        case .surpriseList:
            dic["emptyStr"] = "20"
        case .prizeList:
            dic["emptyStr"] = "20"
        case .activityCenter:
            dic["emptyStr"] = "20"
        case .leagueList (let groupId):
            dic["groupId"] = groupId
        case .leagueDetail(let leagueId, let seasonId):
            dic["leagueId"] = leagueId
            dic["seasonId"] = seasonId
        case .lottoPrizeList(let page, let lotteryId):
            dic["page"] = page
            dic["size"] = "20"
            dic["lotteryClassify"] = lotteryId
        case .lottoPrizeDetail(let termNum, let lotteryId) :
            dic["termNum"] = termNum
            dic["lotteryClassify"] = lotteryId
        case .schoolList:
            dic["emptyStr"] = "20"
        case .matchPrizeList(let date, let lotteryId):
            dic["dateStr"] = date
            dic["lotteryClassify"] = lotteryId
        case .teamDetail(let teamId):
            dic["teamId"] = teamId
        case .surpriseMoreList:
            dic["emptyStr"] = ""
        case .serviceList:
            dic["emptyStr"] = ""
        default:
            return .requestPlain
        }
        
        var dict : [String: Any] = [:]
        dict["body"] = dic
        dict["device"] = DeviceManager.share.device.toJSON()
        
        let jsonStr = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        
        return .requestData(jsonStr!)
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json",
                "token" : UserInfoManager().getToken()
            //"token" : "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxZDg4OTYxZDUtYjI0Yi00NzAxLWJhZWMtNzBkZmUxY2MwMDAzIiwidXNlcklkIjoiNDAwMDY4In0.1aBwA_Rasiew0kiLK8uR3AiUGj1iJ6ZZ8Hvup5v8tNUVMpQWWHVQBSrUBGCxZ28Lmsk0I-cQGQkOcAdoJKJQE1GGjDqSfAWGD951Kyq187C_axWKNazkRK1b-RIuuXV4ZSSSYhn0o45KsLCUh1YO76Q19oFnuVCbrF8DTvXTbSY"
        ]
    }
    
    var method : Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    
}
