//: [Previous](@previous)

1
let priorities = "_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"


func part1(data: String) {
    let itemprios: [Int] = data.split(separator: "\n").map {
        let item = String($0)
        let len = item.count
        let partlen = len / 2
        let p1Start = String.Index(utf16Offset: 0, in: item)
        let p1End = String.Index(utf16Offset: partlen - 1, in: item)
        let p2Start = String.Index(utf16Offset: partlen, in: item)
        let p2End = String.Index(utf16Offset: len - 1, in: item)
        
        let s1 = String(item[p1Start...p1End])
        let s2 = String(item[p2Start...p2End])
        
        guard let similarchar: Character = s1.reduce("_", { [s2] result, char in
            if s2.firstIndex(of: char) != nil {
                return char
            }
            return result
        }) else { return 0 }
        guard let index = priorities.firstIndex(of: similarchar) else { return 0 }
        return priorities.distance(from: priorities.startIndex, to: index)
    }
    
    let priosum = itemprios.reduce(0) { partialResult, prio in
        partialResult + prio
    }
    
    print("Priority sum part 1: \(priosum)")
}

func part2(data: String) {
    var index: Int = 0
    let dict: [Int: [String]] = data.split(separator: "\n").reduce([0: [], 1: [], 2: []], { partialResult, item in
        var newResult = partialResult
        newResult[index]?.append(String(item))
        index = index == 2 ? 0 : index + 1
        return newResult
    })
    guard let data0 = dict[0], let data1 = dict[1], let data2 = dict[2],
          data0.count == data1.count && data1.count == data2.count else {
            fatalError("Something went wrong")
    }
    
    let itemprios: [Int] = data0.enumerated().map { element in
        let index = element.0
        let item = element.1
        let threeItems: [String] = [item, data1[index], data2[index]].sorted {
            $0.count > $1.count
        }
        guard let similarchar: Character = threeItems[0].reduce("_", { partialResult, char in
            if threeItems[1].firstIndex(of: char) != nil && threeItems[2].firstIndex(of: char) != nil {
                return char
            }
            return partialResult
        }) else { fatalError("Something went wrong") }
        guard let index = priorities.firstIndex(of: similarchar) else { return 0 }
        return priorities.distance(from: priorities.startIndex, to: index)
    }

    let priosum = itemprios.reduce(0) { partialResult, prio in
        partialResult + prio
    }
    print("Priority sum part 2: \(priosum)")
}

if let data = readData() {
    part1(data: data)
    part2(data: data)
}

//: [Next](@next)
