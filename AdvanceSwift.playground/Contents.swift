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
    PlaygroundPage.current.liveView = view
    PlaygroundPage.current.needsIndefiniteExecution = true
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





		