//
//  MusicInfo.swift
//  MusicList
//
//  Created by 袁平 on 2020/1/27.
//  Copyright © 2020 袁平. All rights reserved.
//

import SwiftyJSON

struct MusicInfo {
    let name: String
    let id: Int64

    public init(json: JSON) {
        name = json["name"].stringValue
        id = json["id"].int64Value
    }
}

enum MusicSource: String {
    case netease = "netease"
    case tencent = "tencent"
    case baidu = "baidu"
    case xiami = "xiami"
}

enum MusicID: Int64 {
    case cloudHot = 3778678 // 云音乐热歌榜
    case ticTocHot = 2248307886 // 抖音热歌
    case cloudNew = 3779629 // 云音乐新歌榜
    case chineseHot = 4395559 // 华语金曲榜
    case chinaTopOfInner = 64016 // 中国TOP排行榜（内地榜）
    case chinaTopOfHKT = 112504 // 中国TOP排行榜（港台榜）
    case cloudSoar = 19723756 // 云音乐飙升榜
    case cloudOrigin = 2884035 // 网易原创歌曲榜
    case classicOld = 440103454 // 经典怀旧
}
