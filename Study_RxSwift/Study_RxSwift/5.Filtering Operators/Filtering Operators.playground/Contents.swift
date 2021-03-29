import UIKit
import RxSwift

public func example(of description: String,
                    action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

example(of: "ignoreElements") { // next 이벤트 금지, completed, error 이벤트 가능
    // 1
    let strikes = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    // 2
    strikes
        .ignoreElements()
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
    
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onNext("X")
    
    strikes.onCompleted()
}

example(of: "elementAt") { // 입력한 인덱스 번호만 이벤트 수신
    // 1
    let strikes = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    // 2
    strikes
        .elementAt(1)
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
    
    strikes.onNext("X")
    strikes.onNext("Y")
    strikes.onNext("Z")
}

example(of: "filter") { // emit할 값에 대한 조건을 명시적으로 설정
    let disposeBag = DisposeBag()
    
    // 1
    Observable.of(1,2,3,4,5,6)
        // 2
        .filter { $0.isMultiple(of: 2) }
        //3
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "skip") { // 입력한 갯수 만큼 이벤트 skip
    let disposeBag = DisposeBag()
    
    // 1
    Observable.of("A","B","C","D","E","F")
        // 2
        .skip(3)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "skipWhile") { // 조건에 만족하는 것을 skip, 조건이 맞는 원소가 발견되고 그 값이 연속적이면 계속 skip, 단 1회성
    let disposeBag = DisposeBag()
    
    // 1
    Observable.of(2,2,3,4,4)
        // 2
        .skipWhile { $0.isMultiple(of: 2) }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "skipUntil") { // 또 다른 subject를 두어서, 이 이벤트가 발생하기 전까지 event들을 skip
    let disposeBag = DisposeBag()
    
    // 1
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    
    // 2
    subject
        .skipUntil(trigger)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    subject.onNext("A")
    subject.onNext("B")
    
    trigger.onNext("X")
    
    subject.onNext("C")
}

example(of: "take") { // 입력한 갯수 만큼 이벤트 허용
    let disposeBag = DisposeBag()
    
    // 1
    Observable.of(1,2,3,4,5,6)
        // 2
        .take(3)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "takeWhile") { // 특정 조건까지 emit
    let disposeBag = DisposeBag()
    
    // 1
    Observable.of(2,2,4,4,6,6)
        // 2
        .enumerated() // index와 배열의 원소 값을 얻을 수 있게끔 설정
        // 3
        .takeWhile { index, integer in
            // 3
            integer.isMultiple(of: 2) && index < 3
        }
        // 5
        .map(\.element)
        // 6
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "takeUntil") {
    let disposeBag = DisposeBag()
    
    // 1
    Observable.of(1,2,3,4,5)
        // 2
        .takeUntil(.exclusive) { $0.isMultiple(of: 4) } // 조건에 맞는 element까지 => exclusive: 미포함, inclusive: 포함
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "takeUntil trigger") { // 또 다른 subject를 두어서, 이 이벤트가 발생하기 전까지 event들을 emit
    let disposeBag = DisposeBag()
    
    // 1
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    
    // 2
    subject
        .takeUntil(trigger)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    // 3
    subject.onNext("1")
    subject.onNext("2")
    
    trigger.onNext("X")
    
    subject.onNext("3")
}

example(of: "distinctUntilChanged") { // 중복값 방지
    let disposeBag = DisposeBag()
    
    // 1
    Observable.of("A","A","B","B","A")
        // 2
        .distinctUntilChanged()
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "distinctUntilChanged(_:)") {
    let disposeBag = DisposeBag()
    
    // 1
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    // 2
    Observable<NSNumber>.of(10,110,20,200,210,310)
        // 3
        .distinctUntilChanged { a, b in
            // 4
            guard let aWords = formatter.string(from: a)?.components(separatedBy: " "), let bWords = formatter.string(from: b)?.components(separatedBy: " ") else { return false }
            
            var containsMatch = false
            
            // 5
            for aWord in aWords where bWords.contains(aWord) {
                containsMatch = true
                break
            }
            
            return containsMatch
        }
        // 6
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}
