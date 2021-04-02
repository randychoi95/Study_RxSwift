import UIKit
import RxSwift
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

example(of: "startWith") {
    // 1
    let numbers = Observable.of(2,3,4)
    
    // 2
    let observable = numbers.startWith(1)
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "Observable.concat") {
    // 1
    let first = Observable.of(1,2,3)
    let second = Observable.of(4,5,6)
    
    // 2
    let observable = Observable.concat([first, second])
    
    observable.subscribe(onNext: { value in
        print(value)
    })
    
}
