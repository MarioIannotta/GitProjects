//
//  CommandLineManager+Git.swift
//  GitStats
//
//  Created by Mario Iannotta on 17/03/2020.
//  Copyright © 2020 Mario Iannotta. All rights reserved.
//

import Foundation

extension CommandLineManager {
    enum Commands: CommandLineCommand {
        case fetchAll(repoPath: String)
        case switchBranch(repoPath: String, branch: String)
        case updatePod(repoPath: String, name: String?)

        var stringValue: String {
            switch self {
            case .fetchAll(let path):
                return "cd \"\(path)\"; git fetch --all &> /dev/null"
            case .switchBranch(let repoPath, let branch):
                return "cd \"\(repoPath)\"; git switch \(branch)"
            case .updatePod(let repoPath, let podName):
                return "cd \"\(repoPath)\"; \(podName.map { "pod update \($0)" } ?? "pod update")"
            }
        }
    }
    
    @discardableResult func executeCommand(_ command: Commands) -> String {
        executeCommand(command.stringValue)
    }
    

    func listRepo(in path: String) -> [Repository] {
        let command = "find \"$(cd \(path); pwd)\" -name \".git\""
        return executeCommand(command)
            .components(separatedBy: .newlines)
            .map {
                let repoPath = $0.replacingOccurrences(of: "/.git", with: "")
                let repoName = repoPath.components(separatedBy: "/").last
                return Repository(name: repoName ?? repoPath, path: repoPath)
        }
    }

    func listCommits(repo: Repository, since date: String) -> [Commit] {
        let logSeparator = "|||||"
        let command = "cd \"\(repo.path)\"; git log --all --since \"\(date) 00:00:00\" --format=\"##%H\(logSeparator)%aN <%aE>\(logSeparator)%ai\" --shortstat"
        return executeCommand(command)
            .components(separatedBy: "##")
            .compactMap { rawCommit in
                let components = rawCommit.components(separatedBy: "\n\n ")
                guard
                    components.count == 2
                    else {
                        return nil
                    }
                let info = components[0].components(separatedBy: logSeparator)
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
                return Commit(app: repo.name, hash: info[0], author: info[1], date: commitDate, changesCount: changesCount)
            }
    }
}
