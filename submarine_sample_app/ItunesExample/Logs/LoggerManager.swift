//
//  LoggerManager.swift
//  ItunesExample
//
//  Created by Roman Filippov on 28.01.2021.
//

import Foundation
import XCGLogger

class LoggerManager {
    
    static func configureLogger() {
        let logger = XCGLogger.default
        let level: XCGLogger.Level
        #if DEBUG
        level = .verbose
        #else
        level = .info
        #endif
        logger.outputLevel = level
        logger.add(destination: fileDestination(owner: logger, level: level))
        logger.logAppDetails()
    }
    
    static func fileDestination(owner: XCGLogger, level: XCGLogger.Level) -> DestinationProtocol {
        let filePath = FileManager.documentsDirectory.appendingPathComponent("itunes_app_log.txt")
        let destination = FileDestination(owner: owner, writeToFile: filePath, identifier: "ITunesExample.FileLogDestination")
        
        destination.showLogIdentifier = false
        destination.showFunctionName = false
        destination.showThreadName = false
        destination.showLevel = true
        destination.showFileName = true
        destination.showLineNumber = true
        destination.showDate = true
        destination.outputLevel = level
        
        // Process this destination in the background
        destination.logQueue = XCGLogger.logQueue
        return destination
    }
}
