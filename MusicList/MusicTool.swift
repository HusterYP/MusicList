//
//  MusicTool.swift
//  MusicList
//
//  Created by 袁平 on 2020/1/27.
//  Copyright © 2020 袁平. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Alamofire

class MusicTool {
    public static let shared = MusicTool()

    private let const = Const()
    private let disposeBag = DisposeBag()
    private let musicSource: String = MusicSource.netease.rawValue

    public func allMusicListOf(id: Int64) -> Observable<[MusicInfo]> {
        let params: Parameters = ["types": "playlist",
                                  "id": id]
        return Observable<[MusicInfo]>.create { [weak self] (observer) -> Disposable in
            guard let `self` = self else { return Disposables.create() }
            Alamofire.request(self.const.baseUrl,
                              method: .post,
                              parameters: params,
                              encoding: URLEncoding.httpBody,
                              headers: nil)
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let json):
                        let data = JSON(json)
                        observer.onNext(self.buildMusicInfoOfId(data: data))
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }

    public func fetchMusicUrl(id: Int64) -> Observable<String> {
        return Observable.create { [weak self](observer) -> Disposable in
            guard let `self` = self else { return Disposables.create() }
            let params: Parameters = ["types": "url",
                                      "id": id,
                                      "source": self.musicSource]
            Alamofire.request(self.const.baseUrl,
                              method: .post,
                              parameters: params,
                              encoding: URLEncoding.httpBody)
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        observer.onNext(json["url"].stringValue)
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }

    public func searchMusicOf(author: String, page: Int, count: Int) -> Observable<[MusicInfo]> {
        return Observable.create { (observer) -> Disposable in
            let params: Parameters = ["types": "search",
                                      "count": count,
                                      "source": self.musicSource,
                                      "pages": page,
                                      "name": author]
            Alamofire.request(self.const.baseUrl,
                              method: .post,
                              parameters: params,
                              encoding: URLEncoding.httpBody)
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        observer.onNext(self.buildMusicInfoOfSearch(data: json))
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }

    public func downloadMusic(url: String, name: String) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("Music/\(name).mp3")
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(url,
                           method: .get,
                           to: destination)
            .responseData { (response) in
                print("\(response)")
        }
    }

    public func downloadMusic(id: Int64, name: String)  {
        fetchMusicUrl(id: id)
            .subscribe { [weak self](url) in
                guard let `self` = self else { return }
                self.downloadMusic(url: url.element ?? "", name: name)
        }.disposed(by: disposeBag)
    }
}

extension MusicTool {
    private func buildMusicInfoOfId(data: JSON) -> [MusicInfo] {
        guard data["code"].intValue == 200 else { return [] }
        let res = data["playlist"]["tracks"].arrayValue
        var infos: [MusicInfo] = []
        res.forEach { (json) in
            let info = MusicInfo(json: json)
            infos.append(info)
        }
        return infos
    }

    private func buildMusicInfoOfSearch(data: JSON) -> [MusicInfo] {
        var infos: [MusicInfo] = []
        data.arrayValue.forEach { (json) in
            let info = MusicInfo(json: json)
            infos.append(info)
        }
        return infos
    }
}

// MARK: Const
extension MusicTool {
    struct Const {
        let baseUrl = "http://www.gequdaquan.net/gqss/api.php"
        let basePath = "/Users/yuanping/Downloads/Music"
        let ids = ID()
    }

    struct ID {
        let cloudHot: Int64 = 3778678 // 云音乐热歌榜
        let ticTocHot: Int64 = 2248307886 // 抖音热歌
        let cloudNew: Int64 = 3779629 // 云音乐新歌榜
        let chineseHot: Int64 = 4395559 // 华语金曲榜
        let chinaTopOfInner: Int64 = 64016 // 中国TOP排行榜（内地榜）
        let chinaTopOfHKT: Int64 = 112504 // 中国TOP排行榜（港台榜）
        let cloudSoar: Int64 = 19723756 // 云音乐飙升榜
        let cloudOrigin: Int64 = 2884035 // 网易原创歌曲榜
        let classicOld: Int64 = 440103454 // 经典怀旧
    }
}
