//
//  StringExtensions.swift
//  GameOfLife
//
//  Created by Kirill Yakimovich on 2/5/17.
//  Copyright © 2017 Kirill Yakimovich. All rights reserved.
//

import Foundation

/// http://www.conwaylife.com/wiki/RLE
/// Run Length Encoded (RLE)
/// Probably there is an academia name for such compression, but i don't know it
/// Line is encoded as a sequence of items of the form <run_count><symbol>, where <run_count> is the number of occurrences of <symbol>. <run_count> can be omitted if it is equal to 1
/// Example: after compression line "abbaaa" is "a2b3a"

extension String {
    func expandTags() -> String {
        var result = String()
        let scanner = Scanner(string: self)
        while !scanner.isAtEnd {
            var runCount = 1
            scanner.scanInt(&runCount)
            let range = NSMakeRange(scanner.scanLocation, 1)
            let tag = (self as NSString).substring(with: range)
            // Should we distinguish betwee runCount == 1 and runCount > 1?
            result.append(repeatElement(tag, count: runCount).joined())
            scanner.scanLocation += 1
        }
        
        return result
    }
    
    func compressTags() -> String {
        return self.characters.group().map { tags in
            let tag = String(tags.first!)
            if tags.count == 1 {
                return tag
            } else {
                return String(tags.count).appending(tag)
            }
        }.joined()
    }
}
