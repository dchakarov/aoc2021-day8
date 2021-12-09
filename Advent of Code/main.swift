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

func main2() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }

    let lines = inputString.components(separatedBy: "\n")
        .filter { !$0.isEmpty }

    let result = lines.reduce(0, { partialResult, line in
        let lineParts = line.components(separatedBy: " | ")
        let key = findLetters(lineParts[0].components(separatedBy: " "))
        let output = calc(lineParts[1].components(separatedBy: " "), key: key)

        return partialResult + output
    })

    print(result)

}

//main()
main2()

func calc(_ digits: [String], key: [String: String]) -> Int {
    let result = digits
        .map { Set($0).sorted().map(String.init).joined(separator: "") }
        .map { key[$0]! }
        .joined(separator: "")

    return Int(result)!
}

func findLetters(_ line: [String]) -> [String: String] {
    var result = [String: String]()

    let cf = Set(line.filter { $0.count == 2 }[0])
    let acf = Set(line.filter { $0.count == 3 }[0])
    let bcdf = Set(line.filter { $0.count == 4 }[0])
    let abcdefg = Set(line.filter { $0.count == 7 }[0])
    let a = acf.subtracting(cf)
    let bd = bcdf.subtracting(cf)
    let bcdefg = abcdefg.subtracting(a)
    let eg = bcdefg.subtracting(bcdf)
    let sixLetter = line.filter { $0.count == 6 }.map { Set($0) }
    let abcdfg = sixLetter.filter { !eg.isSubset(of: $0) }[0]
    let e = eg.filter { !abcdfg.contains($0) }
    let g = eg.subtracting(e)

    let zero_six = sixLetter.filter { eg.isSubset(of: $0) }
    let cd = zero_six[0].symmetricDifference(zero_six[1])

    let c = cf.intersection(cd)
    let d = bd.intersection(cd)
    let b = bd.subtracting(d)
    let f = cf.subtracting(c)

    let acdfg = abcdfg.subtracting(b)
    let abdefg = abcdefg.subtracting(c)
    let abdfg = abdefg.subtracting(e)
    let acdeg = acdfg.subtracting(f).union(e)
    let abcefg = abcdefg.subtracting(d)

//    print("A = \(a)")
//    print("B = \(b)")
//    print("C = \(c)")
//    print("D = \(d)")
//    print("E = \(e)")
//    print("F = \(f)")
//    print("G = \(g)")
//
//    print("0 = \(abcefg)")
//    print("1 = \(cf)")
//    print("2 = \(acdeg)")
//    print("3 = \(acdfg)")
//    print("4 = \(bcdf)")
//    print("5 = \(abdfg)")
//    print("6 = \(abdefg)")
//    print("7 = \(acf)")
//    print("8 = \(abcdefg)")
//    print("9 = \(abcdfg)")

    result[abcefg.sorted().map(String.init).joined(separator: "")] = "0"
    result[cf.sorted().map(String.init).joined(separator: "")] = "1"
    result[acdeg.sorted().map(String.init).joined(separator: "")] = "2"
    result[acdfg.sorted().map(String.init).joined(separator: "")] = "3"
    result[bcdf.sorted().map(String.init).joined(separator: "")] = "4"
    result[abdfg.sorted().map(String.init).joined(separator: "")] = "5"
    result[abdefg.sorted().map(String.init).joined(separator: "")] = "6"
    result[acf.sorted().map(String.init).joined(separator: "")] = "7"
    result[abcdefg.sorted().map(String.init).joined(separator: "")] = "8"
    result[abcdfg.sorted().map(String.init).joined(separator: "")] = "9"


    return result
}

/*

 1. find 1 (CF)
 2. find 7 (ACF)
 3. deduce A
 4. find 4 (BCDF)
 5. deduce BD
 6. find 8 (ABCDEFG)
 7. deduce EG
 8. find which of 6-letter don't contain both EG -> find E
 9. find G
 10.


 1 (2): CF
 7 (3): ACF
 4 (4): BCDF
 2 (5): ACDEG
 3 (5): ACDFG
 5 (5): ABDFG
 0 (6): ABCEFG
 6 (6): ABDEFG
 9 (6): ABCDFG
 8 (7): ABCDEFG

 */
