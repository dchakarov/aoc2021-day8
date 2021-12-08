//
//  main.swift
//  No rights reserved.
//

import Foundation
import RegexHelper

func main() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }
    
    let lines = inputString.components(separatedBy: "\n")
        .filter { !$0.isEmpty }


    let result = lines.reduce(0) { partialResult, line in
        partialResult + line
            .components(separatedBy: " | ")
            .last!
            .components(separatedBy: " ")
            .filter { [2, 3, 4, 7].contains($0.count) }
            .count
    }

    print(result)
}

main()

/*
 0 (6): abcefg
 1 (2): cf
 2 (5): acdeg
 3 (5): acdfg
 4 (4): bcdf
 5 (5): abdfg
 6 (6): abdefg
 7 (3): acf
 8 (7): abcdefg
 9 (6): abcdfg
 */
