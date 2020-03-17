//
//  Contribution.swift
//  GitStats
//
//  Created by Mario on 17/03/2020.
//  Copyright © 2020 Mario Iannotta. All rights reserved.
//

import Foundation

struct Contribution: Encodable {

    struct Author: Encodable {

        struct App: Encodable {
            var name: String = ""
            var contribution: Int = 0
        }

        var email: String = ""
        var apps: [App] = []
    }
    
    var date: String = ""
    var authors: [Author] = []
}
