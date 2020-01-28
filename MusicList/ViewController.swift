//
//  ViewController.swift
//  MusicList
//
//  Created by 袁平 on 2020/1/27.
//  Copyright © 2020 袁平. All rights reserved.
//

import Cocoa
import RxSwift

class ViewController: NSViewController {
    let const = MusicTool.Const()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMusicList()
    }

    private func fetchMusicList() {
        MusicTool.shared.searchMusicOf(author: "邓紫棋", page: 1, count: 40)
            .subscribe({ (infos) in
                infos.element?.forEach({ (info) in
                    MusicTool.shared.downloadMusic(id: info.id, name: info.name)
                })
            })
            .disposed(by: disposeBag)
    }
}

