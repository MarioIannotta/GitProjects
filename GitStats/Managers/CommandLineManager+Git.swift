//
//  CommandLineManager+Git.swift
//  GitStats
//
//  Created by Mario Iannotta on 17/03/2020.
//  Copyright © 2020 Mario Iannotta. All rights reserved.
//

import Foundation

extension CommandLineManager {

    private static let logSeparator = "|||||"

    private enum Commands: CommandLineCommand {
        case listRepo(path: String)
        case fetchAll(repoPath: String)
        case listCommits(repoPath: String, sinceDate: String)

        var stringValue: String {
            switch self {
            case .listRepo(let path):
                return "find \"$(cd \(path); pwd)\" -name \".git\""
            case .fetchAll(let path):
                return "cd \"\(path)\"; git fetch --all &> /dev/null"
            case .listCommits(let repoPath, let date):
                return "cd \"\(repoPath)\"; git log --all --since \"\(date) 00:00:00\" --format=\"##%H\(logSeparator)%aN <%aE>\(logSeparator)%ai\" --shortstat"
            }
        }
    }

    func listRepo(in path: String) -> [String] {
        executeCommand(Commands.listRepo(path: path))
            .components(separatedBy: .newlines)
            .map { $0.replacingOccurrences(of: "/.git", with: "") }
    }

    func fetchAll(repoPath: String) {
        executeCommand(Commands.fetchAll(repoPath: repoPath))
    }

    func listCommits(repoPath: String, since date: String) -> [Commit] {
        return executeCommand(Commands.listCommits(repoPath: repoPath, sinceDate: date))
            .components(separatedBy: "##")
            .compactMap { rawCommit in
                let components = rawCommit.components(separatedBy: "\n\n ")
                guard
                    components.count == 2
                    else {
                        return nil
                    }
                let info = components[0].components(separatedBy: CommandLineManager.logSeparator)
                guard
                    info.count == 3,
                    let commitDate = info[2].components(separatedBy: " ").first
                    else {
                        return nil
                    }
                let changesCount = components[1]
                    .components(separatedBy: ", ")
                    .compactMap { Int($0.components(separatedBy: " ").first ?? "") }
                    .reduce(0, +)
                return Commit(hash: info[0], author: info[1], date: commitDate, changesCount: changesCount)
            }

    }
}
