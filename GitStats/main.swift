//
//  main.swift
//  GitStats
//
//  Created by Mario Iannotta on 17/03/2020.
//  Copyright © 2020 Mario Iannotta. All rights reserved.
//

import Foundation
import ArgumentParser

struct GitProjects: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "gitprojects",
        subcommands: [FetchContributions.self, PodUpdate.self])
}

GitProjects.main()
