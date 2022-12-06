//: [Previous](@previous)

import Foundation

print("Advent of Code 22 - Day 5")


extension Int {
    public func isBetween(_ from: Int, and to: Int) -> Bool {
        self >= from && self <= to
    }
}

typealias Matrix = [[Character]]
typealias MovingFunction = (Matrix, Int, Int, Int) -> Matrix

fileprivate func readData() -> String? {
    guard let url = Bundle.main.url(forResource: "crates", withExtension: "txt"),
          let calories = try? Data(contentsOf: url) else {
        print("No Input")
        return nil
    }

    return String(decoding: calories, as: UTF8.self)
}

let numberOfStacks = 9
let indexes: [Int] = [1, 5, 9, 13, 17, 21, 25, 29, 33]

private func makeCrateStacks(lines: [String.SubSequence]) -> Matrix {

    var matrix: Matrix = [
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        []
    ]

    guard let emptyIndex = lines.firstIndex(where: { $0.contains(" 1   2   3   4") }) else { return matrix }
    let lastLine = emptyIndex
    for line in 0..<lastLine {
        let newLine = String(lines[line]) + "                                        "
        for stack in 0..<numberOfStacks {
            let index = String.Index(utf16Offset: indexes[stack], in: newLine)
            let char = newLine[index]
            if char != " " {
                matrix[stack].insert(char, at: 0)
            }
        }
    }

    return matrix
}

if let data = readData() {
    move(data: data) { stacks, num, from, to in
        var stacks = stacks
        for _ in 0..<num {
            guard let char = stacks[from - 1].last else {
                fatalError("No create to move")
            }

            stacks[from - 1].removeLast()
            stacks[to - 1].append(char)
        }
        return stacks
    }

    move(data: data) { stacks, num, from, to in
        var stacks = stacks

        var tmpStack: [Character] = []
        for _ in 0..<num {
            guard let char = stacks[from - 1].last else {
                fatalError("No create to move")
            }

            stacks[from - 1].removeLast()
            tmpStack.append(char)
        }
        tmpStack.reversed().forEach { char in
            stacks[to - 1].append(char)
        }

        return stacks
    }
}

func move(data: String, moving: MovingFunction) {
    let lines = data.split(separator: "\n")

    var stacks = makeCrateStacks(lines: lines)

    lines.forEach { line in
        if line.starts(with: "move") {
            let parts = line.split(separator: " ")
            guard let num = Int(parts[1]),
                  let from = Int(parts[3]), from.isBetween(1, and: 9),
                  let to = Int(parts[5]), to.isBetween(1, and: 9) else {
                fatalError("Wrong line format \(line) or out of bounds")
            }
            stacks = moving(stacks, num, from, to)
        }
    }

    let topCreates = stacks.map {
        if let last = $0.last {
            return "\(last)"
        } else {
            return " "
        }
    }
    print("top creates are \(topCreates.joined())")

}


//: [Next](@next)
