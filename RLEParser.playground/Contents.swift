import Cocoa

// http://www.conwaylife.com/wiki/RLE

struct RLEHeader {
    let x: Int // width
    let y: Int // height
    let rule: String? // TBI
}

struct Pattern {
    // b - dead
    // o - alive
    // $ - end of line
    let header: RLEHeader
    init(header: RLEHeader, strings: [String]) {
        self.header = header
        var result = [[Int]]()
        strings.flatMap { str in
            let rows = str.components(separatedBy: "$")
            for row in rows {
                var intRow = [Int]()
                let scanner = Scanner(string: row);
                while !scanner.isAtEnd
                {
                    var runCount = 1
                    scanner.scanInt(&runCount)
                    
                    let range = NSMakeRange(scanner.scanLocation, 1)
                    let tag = (row as NSString).substring(with: range)
                    var cellType: Int? = nil
                    if tag == "b" {
                        cellType = 0
                    } else if tag == "o" {
                        cellType = 1
                    }
                    if let cellType = cellType {
                        intRow.append(contentsOf: [Int](repeating: cellType, count: runCount))
                    }
                    scanner.scanLocation += 1
                }
                result.append(intRow)
            }
        }
        print(result)
    }
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

if let url = Bundle.main.url(forResource: "glider", withExtension: "rle") {
    if let string = try? String(contentsOf: url) {
        
        var lines = [String]()
        string.enumerateLines(invoking: { (line, _) in
            lines.append(line)
        })
        
        let code = lines.filter({ (line) -> Bool in
            return line.characters.first != "#"
        })
        
        if let header = RLEHeader(header: code.first) {
            let contents = Array(code.dropFirst())
            let pattern = Pattern(header: header, strings: contents)
        }
    }
}
