//
//  Commit.swift
//  GitStats
//
//  Created by Mario on 17/03/2020.
//  Copyright © 2020 Mario Iannotta. All rights reserved.
//

import Foundation

struct Commit {
    var app = ""
    let hash: String
    let author: String
    let date: String
    let changesCount: Int
}
