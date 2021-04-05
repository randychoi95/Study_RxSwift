import UIKit
import RxSwift

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

example(of: "concat") {
    let germanCities = Observable.of("Berlin", "Munich", "Frankfurt")
    let spanishCities = Observable.of("Madrid", "Valencia")
    
    let observable = germanCities.concat(spanishCities)
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "concatMap") {
    // 1
    let sequences = [ "German cities": Observable.of("Berlin", "Munich", "Frankfrut"), "Spanish cities": Observable.of("Madrid", "Barcelona", "Valencia")]
    
    // 2
    let observable = Observable.of("German cities", "Spanish cities")
        .concatMap { country in sequences[country] ?? .empty() }
    
    // 3
    _ = observable.subscribe(onNext: { string in
        print(string)
    })
}

example(of: "merge") {
    // 1
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    
    // 2
    let source = Observable.of(left.asObserver(), right.asObserver())
    
    // 3
    let observable = source.merge()
    
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
    
    // 4
    var leftValues = ["Berlin", "Munich", "Frankfrut"]
    var rightValues = ["Madrid", "Barcelona", "Valencia"]
    repeat {
        switch Bool.random() {
        case true where !leftValues.isEmpty:
            left.onNext("Left: " + leftValues.removeFirst())
        case false where !rightValues.isEmpty:
            right.onNext("Right: " + rightValues.removeFirst())
        default:
            break
        }
    } while !leftValues.isEmpty || !rightValues.isEmpty
    
    // 5
    left.onCompleted()
    right.onCompleted()
}

example(of: "combineLatest") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    
    // 1
//    let observable = Observable.combineLatest(left, right) {
//        lastLeft, lastRight in
//        "\(lastLeft) \(lastRight)"
//    }
    let observable = Observable.combineLatest([left, right]) { strings in
        strings.joined(separator: " ")
    }
    
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
    
    // 2
    print("> Sending a value to Left")
    left.onNext("Hello,")
    print("> Sending a vvalue to Right")
    right.onNext("world")
    print("> Seding another value to Right")
    right.onNext("RxSwift")
    print("> Sending another value to Left")
    left.onNext("Have a good day,")
    left.onCompleted()
    right.onCompleted()
}

example(of: "combine user choice and value") {
    let choice: Observable<DateFormatter.Style> = Observable.of(.short, .long)
    let dates = Observable.of(Date())
    
    let observables = Observable.combineLatest(choice, dates) {
        format, when -> String in
        let formatter = DateFormatter()
        formatter.dateStyle = format
        return formatter.string(from: when)
    }
    
    _ = observables.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "zip") {
    enum Weather {
        case cloudy
        case sunny
    }
    
    let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
    let right = Observable.of("Lisbon","Copenhagen","London","Madrid","Vienna")
    
    let observable = Observable.zip(left, right) { weather, city in
        return "It's \(weather) in \(city)"
    }
    
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "withLatestFrom") {
    // 1
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()
    
    // 2
//    let observable = button.withLatestFrom(textField)
    let observable = textField.sample(button)
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
    
    // 3
    textField.onNext("Par")
    textField.onNext("Pari")
    textField.onNext("Paris")
    button.onNext(())
    button.onNext(())
}

example(of: "amb") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    
    // 1
    let observable = left.amb(right)
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
    
    // 2
    left.onNext("Lisbon")
    right.onNext("Copenhagen")
    left.onNext("London")
    left.onNext("Madrid")
    right.onNext("Vienna")
    
    left.onCompleted()
    right.onCompleted()
}

example(of: "switchLatest") {
    // 1
    let one = PublishSubject<String>()
    let two = PublishSubject<String>()
    let three = PublishSubject<String>()
    
    let source = PublishSubject<Observable<String>>()
    
    // 2
    let observable = source.switchLatest()
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })
    
    // 3
    source.onNext(one)
    one.onNext("Some text from sequence one")
    two.onNext("Some text from sequence two")
    
    source.onNext(two)
    two.onNext("More text from seuence two")
    one.onNext("and also from sequence one")
    
    source.onNext(three)
    two.onNext("Why don't you see me?")
    one.onNext("I'm alone, help me")
    three.onNext("Hey it's three. I win.")
    
    source.onNext(one)
    one.onNext("Nope. It's me, one!")
    
    disposable.dispose()
}

example(of: "reduce") {
    let source = Observable.of(1,3,5,7,9)
    
    // 1
    let observable =  source.reduce(0) { summary, newValue in
        return summary + newValue
    }
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "scan") {
    let source  = Observable.of(1,3,5,7,9)
    
    let observable = source.scan(0, accumulator: +)
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}
