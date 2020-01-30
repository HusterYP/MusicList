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
        MusicTool.shared.register()
    }
}

