//
//  PodUpdate.swift
//  GitStats
//
//  Created by Alberto Saltarelli on 11/08/2020.
//  Copyright © 2020 Mario Iannotta. All rights reserved.
//

import ArgumentParser

struct PodUpdate: ReposCommand {
    static let configuration = CommandConfiguration(commandName: "pod-update")
    
    @Argument(help: "The absolute path that contains all your repositories. eg: /Users/mario/Documents/Apps")
    var basePath: String
    
    @Argument(default: nil, help: "The name of the pod")
    var podName: String?
    
    @Argument(default: "develop", help: "The name of the branch")
    var branch: String
    
    func run() throws {
        let repos = findRepositories()
        let commandLineManager = CommandLineManager()
        
        for repo in repos {
            print(repo.name)
            commandLineManager.executeCommand(.switchBranch(repoPath: repo.path, branch: branch))
            commandLineManager.executeCommand(.updatePod(repoPath: repo.path, name: podName))
            print("____________________________________________________________")
        }
    }
}
