//: [Previous](@previous)

import Foundation

print("Advent of Code 22 - Day 2")

func readData() -> String? {
    guard let url = Bundle.main.url(forResource: "secretstrategy", withExtension: "txt"),
          let calories = try? Data(contentsOf: url) else {
        print("No Input")
        return nil
    }

    return String(decoding: calories, as: UTF8.self)
}

enum Hand {
    case rock
    case paper
    case scissors
    
    static func from(string: String) -> Hand {
        switch string {
        case "A": return .rock
        case "B": return .paper
        case "C": return .scissors
        case "X": return .rock
        case "Y": return .paper
        case "Z": return .scissors
        default: fatalError("Wrong input")
        }
    }
    
    var points: Int {
        switch self {
        case .rock: return 1
        case .paper: return 2
        case .scissors: return 3
        }
    }
}

enum RoundResult: Int {
    case lose = 0
    case draw = 3
    case win = 6
    
    var points: Int { self.rawValue }
}

struct Rule {
    let a: Hand // A=Rock, B=Paper, C=scissors
    let b: Hand // X=Rock, B=Paper, C=scissors
    let points: Int
    let points2: Int
    
    init(_ a: Hand, _ b: Hand) {
        self.a = a
        self.b = b
        switch a {
        case .rock where b == .rock:
            points = RoundResult.draw.points + b.points
            points2 = RoundResult.lose.points + Hand.scissors.points
        case .rock where b == .paper:
            points = RoundResult.win.points + b.points
            points2 = RoundResult.draw.points + Hand.rock.points
        case .rock where b == .scissors:
            points = RoundResult.lose.points + b.points
            points2 = RoundResult.win.points + Hand.paper.points
        case .paper where b == .rock:
            points = RoundResult.lose.points + b.points
            points2 = RoundResult.lose.points + Hand.rock.points
        case .paper where b == .paper:
            points = RoundResult.draw.points + b.points
            points2 = RoundResult.draw.points + Hand.paper.points
        case .paper where b == .scissors:
            points = RoundResult.win.points + b.points
            points2 = RoundResult.win.points + Hand.scissors.points
        case .scissors where b == .rock:
            points = RoundResult.win.points + b.points
            points2 = RoundResult.lose.points + Hand.paper.points
        case .scissors where b == .paper:
            points = RoundResult.lose.points + b.points
            points2 = RoundResult.draw.points + Hand.scissors.points
        case .scissors where b == .scissors:
            points = RoundResult.draw.points + b.points
            points2 = RoundResult.win.points + Hand.rock.points
        default:
            fatalError("Wrong combination")
        }
    }
}

let rules: [Rule] = [
    Rule(.rock,    .rock),
    Rule(.rock,    .paper),
    Rule(.rock,    .scissors),
    Rule(.paper,   .rock),
    Rule(.paper,   .paper),
    Rule(.paper,   .scissors),
    Rule(.scissors, .rock),
    Rule(.scissors, .paper),
    Rule(.scissors, .scissors)
]

if let strategyData = readData() {
    
    let strategy: [(Hand, Hand)] = strategyData.split(separator: "\n").map {
        let round = $0.split(separator: " ")
        return (Hand.from(string: String(round[0])), Hand.from(string: String(round[1])))
    }
    
    let points: (Int, Int) = strategy.reduce((0, 0), { result, hands in
        guard let rule = rules.first(where: { $0.a == hands.0 && $0.b == hands.1 }) else {
            fatalError("Did not find rule: \(hands)")
        }
        return (result.0 + rule.points, result.1 + rule.points2)
    })
    
    print("Points: \(points)")
}

//: [Next](@next)
