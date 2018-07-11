//
//  Logger.swift
//  UIMatters
//
//  Created by Haozhe XU on 3/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import Foundation

protocol LoggerOutput: class {
    func write(message: String)
}

final class Logger {
    
    static let shared = Logger()
    
    weak var output: LoggerOutput?
    
    init(output: LoggerOutput? = nil) {
        self.output = output
    }
    
    func log(message: String, indentLevel: Int = 0, timestamp: Bool = true) {
        var indentation = Array(repeating: ".", count: indentLevel).joined()
        if indentLevel > 0 {
            indentation += " "
        }
        if timestamp {
            output?.write(message: "[\(Date.timeIntervalSinceReferenceDate)] \(indentation)\(message)")
        } else {
            output?.write(message: "\(indentation)\(message)")
        }
    }
}

extension Logger {
    
    static var indentLevel = 0

    func logMethodStart(fileName: String = #file, methodName: String = #function, indent: Bool = true) {
        
        log(message: "\(className(from: fileName)): \(methodName) - start", indentLevel: indent ? Logger.indentLevel : 0, timestamp: false)

        if indent {
            Logger.indentLevel += 1
        }
    }
    
    func logMethodEnd(fileName: String = #file, methodName: String = #function, indent: Bool = true) {
        if indent {
            Logger.indentLevel -= 1
        }

        log(message: "\(className(from: fileName)): \(methodName) - end", indentLevel: indent ? Logger.indentLevel : 0, timestamp: false)
    }
    
    private func className(from file: String) -> String {
        let components = file.components(separatedBy: "/")
        let fileName = components.isEmpty ? "" : components.last!
        if fileName.hasSuffix(".swift") {
            let index = fileName.index(fileName.endIndex, offsetBy: -".swift".count)
            return String(fileName.prefix(upTo: index))
        }
        return fileName
    }
}
