//
//  ReposCommand.swift
//  GitStats
//
//  Created by Alberto Saltarelli on 11/08/2020.
//  Copyright © 2020 Mario Iannotta. All rights reserved.
//

import ArgumentParser

protocol ReposCommand: ParsableCommand {
    var basePath: String { get }
}

extension ReposCommand {
    func findRepositories() -> [Repository] {
        print("Listing git repositories in \(basePath)")
        let commandLineManager = CommandLineManager()
        let repos = commandLineManager.listRepo(in: basePath)
        print("\(repos.count) repositories found: \(repos.map(\.name).joined(separator: ", "))\n")
        return repos
    }
}
