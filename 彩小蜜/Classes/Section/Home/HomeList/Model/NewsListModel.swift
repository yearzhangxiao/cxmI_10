//
//  NewsListModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct NewsListModel: HandyJSON {
    var endRow: String!
    var firstPage: Int!
    var hasNextPage: Bool!
    var hasPreviousPage: Bool!
    var isFirstPage: Bool!
    var isLastPage: Bool!
    var lastPage: Int!
    var navigateFirstPage: Int!
    var nextPage: Int!
    var pageNum: Int!
    var pageSize: Int!
    var pages: Int!
    var prePage: Int!
    var size: Int!
    var startRow: Int!
    var total: Int!
    var list:[NewsInfoModel]!
}

struct NewsInfoModel: HandyJSON {
    /// 发布时间
    var addTime: String!
    ///
    var articleId: String!
    /// 文章缩略图，用“，”分隔
    var articleThumb : [String]!
    /// 阅读量
    var clickNumber: String!
    var isVideo: Bool!
    /// 分类
    var extendCat: String!
    /// 关键字
    var keywords: String!
    /// 转向连接
    var link: String!
    /// 列表展示形式， 1- 单张图 2-两张图 3-三张图
    var listStyle: String!
    /// 比赛ID
    var matchId: String!
    /// 主队-1， 客队-2
    var relatedTeam: String!
    /// 文章摘要
    var summary: String!
    /// 文章标题
    var title: String!
    
    
}
