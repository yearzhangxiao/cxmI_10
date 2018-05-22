//
//  LotteryNetAPIManager.swift
//  彩小蜜
//
//  Created by HX on 2018/3/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Moya
import RxSwift

let lotteryProvider = MoyaProvider<LotteryNetAPIManager>(plugins:[RequestLoadingPlugin()])

enum LotteryNetAPIManager {
    case lotteryResult (date: String, isAlready: Bool, leagueIds: String, finished: Bool)
}

extension LotteryNetAPIManager : TargetType {
    var baseURL : URL {
        return URL(string : baseURLStr + "/lottery" + xpath )!
    }
    
    var xpath : String {
        switch self {
        case .lotteryResult:
            return "/lottery/match/queryMatchResult"
        }
    }
    
    var path : String {
        
        switch self {
        
        case .lotteryResult:
            return ""
        }
    }
    
    var method : Moya.Method {
        switch self {
        
        default:
            return .post
        }
    }
    var headers: [String : String]? {
        return ["Content-Type" : "application/json",
                "token" : UserInfoManager().getToken()
        ]
    }
    var parameters: [String: Any]? {
        switch self {
        
        default:
            return nil
        }
    }
    
    var task: Task {
        var dic : [String: Any] = [:]
        
        switch self {
        case .lotteryResult(let date, let isAlready, let leagueIds, let finished ):
            dic["dateStr"] = date
            if isAlready == false {
                dic["isAlreadyBuyMatch"] = ""
            }else {
                dic["isAlreadyBuyMatch"] = "1"
            }
            if finished {
                dic["matchFinish"] = "1"
            }else{
                dic["matchFinish"] = ""
            }
            
            dic["leagueIds"] = leagueIds
            
        default:
            return .requestPlain
        }
        var dict : [String: Any] = [:]
        dict["body"] = dic
        dict["device"] = DeviceManager.share.device.toJSON()
        let jsonStr = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return .requestData(jsonStr!)
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