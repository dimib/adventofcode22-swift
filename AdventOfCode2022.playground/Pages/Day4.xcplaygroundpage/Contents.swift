//: [Previous](@previous)

import Foundation

print("Advent of Code 22 - Day 4")

fileprivate func readData() -> String? {
    guard let url = Bundle.main.url(forResource: "sections", withExtension: "txt"),
          let calories = try? Data(contentsOf: url) else {
        print("No Input")
        return nil
    }

    return String(decoding: calories, as: UTF8.self)
}


fileprivate func sectionsToString(from: Int, to: Int) -> String {
    var str = ""
    for section in from...to {
        str.append("[\(section)]")
    }
    return str
}

fileprivate func sectionsToArray(from: Int, to: Int) -> [Int] {
    var array: [Int] = []
    for section in from...to {
        array.append(section)
    }
    return array
}

fileprivate func part1(data: String) {
    let teamsCount: Int = data.split(separator: "\n").reduce(0, { partialResult, team in
        let elves = team.split(separator: ",")
        let elf1 = elves[0].split(separator: "-").map { Int($0)! }
        let elf2 = elves[1].split(separator: "-").map { Int($0)! }
        
        let sec1 = sectionsToString(from: elf1[0], to: elf1[1])
        let sec2 = sectionsToString(from: elf2[0], to: elf2[1])
        if sec1.contains(sec2) || sec2.contains(sec1) {
            return partialResult + 1
        }
        return partialResult
    })
    
    print("Teams with equal sections: \(teamsCount)")
}

/// This is realy slow... Can we speed this up?
fileprivate func part2(data: String) {
    let teamsCount: Int = data.split(separator: "\n").reduce(0, { partialResult, team in
        let elves = team.split(separator: ",")
        let elf1 = elves[0].split(separator: "-").map { Int($0)! }
        let elf2 = elves[1].split(separator: "-").map { Int($0)! }
        
        let sec1 = sectionsToArray(from: elf1[0], to: elf1[1])
        let sec2 = sectionsToArray(from: elf2[0], to: elf2[1])
        var overlaps = false
        sec1.forEach { sec in
            if sec2.contains(sec) {
                overlaps = true
            }
        }
        return overlaps ? partialResult + 1 : partialResult
    })
    print("Teams with overlapping sections: \(teamsCount)")
}

if let data = readData() {
    part1(data: data)
    part2(data: data)
}

//: [Next](@next)
