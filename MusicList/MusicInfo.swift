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
