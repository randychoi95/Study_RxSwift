import UIKit
import RxSwift

// Start coding here!
example(of: "solution using zip") {
    let source = Observable.of(1, 3, 5, 7, 9)
    
    let scanObservable = source.scan(0, accumulator: +)
    let observable = Observable.zip(source, scanObservable)
    _ = observable.subscribe(onNext: { value in
        print("current Value: \(value.0) / total Value: \(value.1)")
    })
}

example(of: "solution using just scan and a tuple") {
    let source = Observable.of(1,3,5,7,9)
    let observable = source.scan((0,0)) { current, total in
        return (total, current.1 + total)
    }
    _ = observable.subscribe(onNext: { value in
        print("Value = \(value.0)   Running total = \(value.1)")
    })
}
