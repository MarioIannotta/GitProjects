//
//  main.swift
//  GitStats
//
//  Created by Mario Iannotta on 17/03/2020.
//  Copyright © 2020 Mario Iannotta. All rights reserved.
//

import Foundation
import ArgumentParser

struct GitStats: ParsableCommand {

    private static func makeTodayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: Date())
    }

    @Argument(help: "The absolute path that contains all your repositories. eg: /Users/mario/Documents/Apps")
    var basePath: String

    @Argument(default: GitStats.makeTodayDate(),
              help: "The date from which you want to get the stats. Format: YYYY-MM-dd.")
    var date: String

    @Option(name: .shortAndLong, default: false, help: "If the true, the remote fetch will be skipped.")
    var skipFetch: Bool

    private func fetchCommits() -> [Commit] {
        print("Listing git repositories in \(basePath)")
        let commandLineManager = CommandLineManager()
        let repos = commandLineManager.listRepo(in: basePath)
        let reposNames = repos.compactMap { $0.components(separatedBy: "/").last }
        print("\(repos.count) repositories found: \(reposNames.joined(separator: ", "))\n")
        if !skipFetch {
            repos.enumerated().forEach { index, repoPath in
                print("Fetching commit history for \(reposNames[index])...")
                commandLineManager.fetchAll(repoPath: repoPath)
            }
        }
        let commits = repos.enumerated()
            .flatMap { index, repoPath in
                commandLineManager
                    .listCommits(repoPath: repoPath, since: date)
                    .map { commit -> Commit in
                        var commit = commit
                        commit.app = reposNames[index]
                        return commit
                }
        }
        print("\n\(commits.count) commit found since \(date)")
        return commits
    }

    private func groupContributions(commits: [Commit]) -> [Contribution] {
        var rawContributions = [String: [String: [String: Int]]]() // ["date": ["author": [app: changesCount]]]

        for commit in commits {
            if rawContributions[commit.date] == nil {
                rawContributions[commit.date] = [:]
            }
            if rawContributions[commit.date]?[commit.author] == nil {
                rawContributions[commit.date]?[commit.author] = [:]
            }
            let contribution = commit.changesCount + (rawContributions[commit.date]?[commit.author]?[commit.app] ?? 0)
            rawContributions[commit.date]?[commit.author]?[commit.app] = contribution
        }

        var contributions = [Contribution]()
        for (date, authors) in rawContributions {
            var contribution = Contribution()
            contribution.date = date
            for (authorEmail, apps) in authors {
                var author = Contribution.Author()
                author.email = authorEmail
                for (appName, contribution) in apps {
                    var app = Contribution.Author.App()
                    app.name = appName
                    app.contribution = contribution
                    author.apps.append(app)
                }
                author.apps.sort(by: { $0.contribution > $1.contribution })
                contribution.authors.append(author)
            }
            contribution.authors.sort(by: { $0.email < $1.email })
            contributions.append(contribution)
        }
        contributions.sort(by: { $0.date < $1.date })
        return contributions
    }

    private func printContributionsJSON(_ contributions: [Contribution]) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted

        do {
            let data = try jsonEncoder.encode(contributions)
            let string = String(data: data, encoding: .utf8) ?? ""
            print("\nContributions:\n\(string)")
        } catch let error {
            print(error)
        }
    }

    func run() throws {
        let commits = fetchCommits()
        let contributions = groupContributions(commits: commits)
        printContributionsJSON(contributions)
    }
}

GitStats.main()
