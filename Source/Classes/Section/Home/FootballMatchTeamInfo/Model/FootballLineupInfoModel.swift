//
//  FootballLineupInfoModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct FootballLineupInfoModel : HandyJSON {
    var changci: String!
    var homeTeamAbbr: String!
    /// 联赛
    var leagueAddr: String!
    var matchTime: String!
    var visitingTeamAbbr: String!
    /// 客队替补队员
    var abenchPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 客队受伤队员
    var ainjureiesPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 客队首发队员
    var alineupPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 客队停赛队员
    var asuspensionPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 主队替补队员
    var hbenchPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 主队受伤队员
    var hinjureiesPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 主队首发队员
    var hlineupPersons: [FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    /// 主队停赛队员
    var hsuspensionPersons:[FootballLineupMemberInfo] = [FootballLineupMemberInfo]()
    
    func getHomeLineup() -> [[FootballLineupMemberInfo]] {
        var homeLinup : [[FootballLineupMemberInfo]] = [[FootballLineupMemberInfo]]()
        
        var hGK = [FootballLineupMemberInfo]()
        var hD1 = [FootballLineupMemberInfo]()
        var hM = [FootballLineupMemberInfo]()
        var hA = [FootballLineupMemberInfo]()
        
        for member in hlineupPersons {
            if member.positionX == "GK" {
                hGK.append(member)
            }else if member.positionX == "D1" {
                hD1.append(member)
            }else if member.positionX == "M" {
                hM.append(member)
            }else if member.positionX == "A" {
                hA.append(member)
            }
        }
        
        if hGK.count > 0 {
            homeLinup.append(hGK)
        }
        if hD1.count > 0 {
            homeLinup.append(hD1)
        }
        if hM.count > 0 {
            homeLinup.append(hM)
        }
        if hA.count > 0 {
            homeLinup.append(hA)
        }
        
        return homeLinup
    }
    
    func getVisiLineup() -> [[FootballLineupMemberInfo]] {
        var visiLinup : [[FootballLineupMemberInfo]] = [[FootballLineupMemberInfo]]()
        
        var GK = [FootballLineupMemberInfo]()
        var D1 = [FootballLineupMemberInfo]()
        var M = [FootballLineupMemberInfo]()
        var A = [FootballLineupMemberInfo]()
        
        for member in alineupPersons {
            if member.positionX == "GK" {
                GK.append(member)
            }else if member.positionX == "D1" {
                D1.append(member)
            }else if member.positionX == "M" {
                M.append(member)
            }else if member.positionX == "A" {
                A.append(member)
            }
        }
        
        if A.count > 0 {
            visiLinup.append(A)
        }
        if M.count > 0 {
            visiLinup.append(M)
        }
        if D1.count > 0 {
            visiLinup.append(D1)
        }
        if GK.count > 0 {
            visiLinup.append(GK)
        }
        return visiLinup
    }
}

struct FootballLineupMemberInfo : HandyJSON {
    var personId: String!
    var personName: String!
    ///队员位置
    var position: String!
    ///队员位置X
    var positionX: String!
    ///队员位置Y
    var positionY: String!
}
