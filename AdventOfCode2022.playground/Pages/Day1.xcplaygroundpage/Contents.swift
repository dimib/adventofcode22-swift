//: [Previous](@previous)

import Foundation

print("Advent of Code 22 - Day 1")

func readData() -> String? {
    guard let url = Bundle.main.url(forResource: "calories", withExtension: "txt"),
          let calories = try? Data(contentsOf: url) else {
        print("No Input")
        return nil
    }

    return String(decoding: calories, as: UTF8.self)
}

if let calories = readData() {
    let list = calories.split(separator: "\n\n")
    let calories: [(elf: Int, calories: Int)] = list.enumerated().map { elf, intakes in
        let entries: [Int] = intakes.split(separator: "\n").map { Int($0) ?? 0 }
        let sum: Int = entries.reduce(0) { result, value in
            result + value
        }
        return (elf: elf, calories: sum)
    }.sorted { $0.calories > $1.calories }

    print("Elf with the most calories: \(calories.first?.calories ?? 0)")

    let calories3 = calories.prefix(3).reduce(0) { partialResult, elfCalories in
        partialResult + elfCalories.calories
    }
    print("Three top elves: \(calories3)")
}

//: [Next](@next)
