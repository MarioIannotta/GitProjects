//
//  CommandLineManager.swift
//  GitStats
//
//  Created by Mario Iannotta on 17/03/2020.
//  Copyright © 2020 Mario Iannotta. All rights reserved.
//

import Foundation

protocol CommandLineCommand {
    
    var stringValue: String { get }
    
}

struct CommandLineManager {
    
    @discardableResult
    func executeCommand(_ command: CommandLineCommand) -> String {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", command.stringValue]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)?.droppingFinalCharacter ?? ""
    }

}

private extension String {
    
    var droppingFinalCharacter: String? {
        return String(dropLast())
    }
    
}

