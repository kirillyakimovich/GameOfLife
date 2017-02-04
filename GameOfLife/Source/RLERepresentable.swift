//
//  RLEConvertable.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 2/1/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

// http://www.conwaylife.com/wiki/RLE

import Foundation

struct RLEHeader {
    let x: Int // width
    let y: Int // height
    let rule: String? // To Be Implemented
}

extension RLEHeader {
    init?(header: String?) {
        guard let header = header else {
            return nil
        }
        
        let scanner = Scanner(string: header)
        let toSkip = CharacterSet(charactersIn: "x,y, =")
        scanner.charactersToBeSkipped = toSkip
        var x = 0
        var y = 0
        if scanner.scanInt(&x) && scanner.scanInt(&y) {
            self = RLEHeader(x: x, y: y, rule: "rule")
        } else {
            return nil
        }
    }
}

protocol RLERepresentable {
    func RLERepresentation() -> String
    func header(width: Int, height: Int) -> String
}

extension RLERepresentable {
    init(with RLERepresentation: String) { self.init(with: RLERepresentation) }
    func header(width: Int, height: Int) -> String {
        return "x = \(width), y = \(height)"
    }
}

extension GridModel: RLERepresentable {
    internal func RLERepresentation() -> String {
        return header(width: self.width, height: self.height)
    }

    convenience init?(with RLERepresentation: String) {
        var lines = [String]()
        RLERepresentation.enumerateLines(invoking: { (line, _) in
            lines.append(line)
        })
        
        let code = lines.filter({ (line) -> Bool in
            return line.characters.first != "#"
        })
        
        if let header = RLEHeader(header: code.first) {
            self.init(width: header.x, height: header.y)
            
            let contents = Array(code.dropFirst()).joined()
            let rows = contents.components(separatedBy: "$")
            for (row, rowCode) in rows.enumerated() {
                var startColumn = 0;
                let scanner = Scanner(string: rowCode)
                while !scanner.isAtEnd {
                    var runCount = 1
                    scanner.scanInt(&runCount)
                    let range = NSMakeRange(scanner.scanLocation, 1)
                    let tag = (rowCode as NSString).substring(with: range)
                    
                    if tag == "o" {
                        if (runCount > 1) {
                            for column in startColumn..<(startColumn + runCount) {
                                self.toggleAt(x: row, y: column)
                            }
                        } else {
                            self.toggleAt(x: row, y: scanner.scanLocation)
                        }
                    }
                    scanner.scanLocation += 1
                    startColumn += runCount
                }
            }
        } else {
            return nil
        }
    }
}
