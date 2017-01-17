//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
/*:
 ##
 > switch
 ---
*/

var array = ["one", "two", "three"]
let idx = array.index(of: "four")
switch idx {
//Swift 2.0 中引入了使用 ? 作为在 switch 中对 some 进行匹配的模式后缀的语法，另外，你还可以使用 nil 字面量来匹配 none
case let x?:
    array.remove(at: x)
case nil:
    break
}

/*:
##
> if let
---
*/

if let idx = array.index(of: "four") {
    array.remove(at: idx)
}

//confirm must have one object
if let idx = array.index(of: "four"),
    idx != array.startIndex {
    array.remove(at: idx)
}

//“可以在同一个 if 语句中绑定多个值。更赞的是，后面的绑定值可以基于之前的成功解包的值来进行操作”
let urlString = "https://dn-bts.qbox.me/home/images/text-dynamic.gif"
if let url = URL(string: urlString),
    let data = try? Data(contentsOf: url),
    let image = UIImage(data: data) {
    
    let view = UIImageView(image: image)
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//    PlaygroundPage.current.liveView = view
//    PlaygroundPage.current.needsIndefiniteExecution = true
}

//“while let 语句和 if let 非常相似，它代表一个当遇到 nil 时终止的循环”
let intArray = [1, 2, 3]
var iterator = intArray.makeIterator()

while let i = iterator.next() {
    print(i, terminator: " ")
}

//双重可选值
let stringNumbers = ["1", "2", "three"]
let maybeInts = stringNumbers.map{ Int($0) }

var intIterator = maybeInts.makeIterator()
while let maybeInt = iterator.next() {
    print(maybeInt)
}


//对非nil值,进行处理  x?的模式相当于 .Some(x)的简写形式
for case let i? in maybeInts {
    print(i, terminator: " ")
}


//只处理nil
for case nil in maybeInts {
    print("No value")
}

//运算符重载
precedencegroup ExponentiationPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix operator **: MultiplicationPrecedence

func **(lhs: Double, rhs: Double) -> Double {
    return pow(lhs, rhs)
}

func **(lhs: Float, rhs: Float) -> Float {
    return powf(lhs, rhs)
}

2.0 ** 3.0

func **<I: SignedInteger>(lhs: I, rhs: I) ->I {
    let result = Double(lhs.toIntMax()) ** Double(rhs.toIntMax())
    return numericCast(IntMax(result))
}

//2 ** 3 //will error

let intResult: Int = 2 ** 3



//使用泛型约束进行重载


//时间复杂度: O( n * m )
extension Sequence where Iterator.Element: Equatable {
    func isSubset(of other: [Iterator.Element]) -> Bool {
        for element in self {
            guard other.contains(element) else {
                return false
            }
        }
        return true
    }
}

let oneToThree = [1, 2, 3]
let fiveToOne = [5, 4, 3, 2, 1]
oneToThree.isSubset(of: fiveToOne)

//时间复杂度: O (n + m)
extension Sequence where Iterator.Element: Hashable {
    func isSubset(of other: [Iterator.Element]) -> Bool {
        let otherSet = Set(other)
        for element in self {
            guard otherSet.contains(element) else {
                return false
            }
        }
        return true
    }
}



/*:
 ##
 > 这两个序列类型并不需要是同样的类型
 ---
 */
extension Sequence where Iterator.Element: Hashable {
    func isSubset<S: Sequence>(of other: S) -> Bool
        where S.Iterator.Element == Iterator.Element
    {
        for element in self {
            guard other.contains(element) else {
                return false
            }
        }
        
        return true
    }
}

[5, 4, 3].isSubset(of: 1...10)



/*:
 ##
 > 我们可以对可判等的元素的函数做出同样的更改
 ---
 */
extension Sequence where Iterator.Element: Equatable {
    func isSubset<S: Sequence>(of other: S) -> Bool
        where S.Iterator.Element == Iterator.Element
    {
        for element in self {
            guard other.contains(element) else {
                return false
            }
        }
        return true
    }
}



/*:
 ##
 > 使用闭包对行为进行参数化
 ---
 */

//在标准库中

let isEven = {$0 % 2 == 0}

(0..<5).contains(where: isEven)



///我们可以利用这个更灵活的 contains 版本来写一个同样灵活的 isSubset：
extension Sequence {
    func isSubset<S: Sequence>(of other: S,
                  by areEquivalent: (Iterator.Element, S.Iterator.Element) -> Bool)
        -> Bool
    {
        
        for element in self {
            guard other.contains(where: {areEquivalent(element, $0)}) else {
                return false
            }
        }
        
        return true
    }
}



///我们可以将 isSubset 用在数组的数组上了，只需要为它提供一个闭包表达式，并使用 == 来对数组进行比较：
[[1, 2]].isSubset(of: [[1, 2], [3, 4]], by: { $0 == $1 })



///只要你提供的闭包能够处理比较操作, 2个序列中的元素甚至都不需要是同样的类型

let ints = [1, 2]
let strings = ["1", "2", "3"]
ints.isSubset(of: strings, by: { String($0) == $1 })




///泛型二分查找
extension RandomAccessCollection {
    public func binarySearch(for value: Iterator.Element,
                             areInIncreasingOrder: (Iterator.Element, Iterator.Element) -> Bool)
        -> Index?
    {
        
        guard !isEmpty else { return nil }
        var left = startIndex
        var right = index(before: endIndex)
        
        while left <= right {
            let dist = distance(from: left, to: right)
            let mid = index(left, offsetBy: dist/2)
            let candidate = self[mid]
            
            if areInIncreasingOrder(candidate, value) {
                left = index(after: mid)
            }
            else if areInIncreasingOrder(value, candidate) {
                right = index(before: mid)
            }
            else {
                //“如果两个元素互无顺序关系，那么它们一定相等”
                return mid
            }
        }
        
        return nil
    }
}


[1, 2, 3, 4].binarySearch(for: 2, areInIncreasingOrder: { $0 > $1 })









