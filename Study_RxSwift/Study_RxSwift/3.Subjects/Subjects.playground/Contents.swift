import UIKit
import RxSwift
import RxRelay

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

example(of: "PublishSubject") { // empty상태로 시작, 새로운 이벤트만 subscriber에게 emit // 시간에 민감한 데이터를 모델링 할 경우
    let subject = PublishSubject<String>()
    
    subject.on(.next("Is anyone listening?"))
    
    let subscriptionOne = subject
        .subscribe(onNext: { string in
            print(string)
        })
    
    subject.on(.next("1"))
    subject.onNext("2")
    
    let subscriptionTwo = subject
        .subscribe { event in
            print("2)", event.element ?? event)
        }
    subject.onNext("3")
    
    subscriptionOne.dispose()
    subject.onNext("4")
    
    subject.onCompleted()
    
    subject.onNext("5")
    
    subscriptionTwo.dispose()
    
    let disposeBag = DisposeBag()
    
    subject
        .subscribe {
            print("3)", $0.element ?? $0)
        }
        .disposed(by: disposeBag)
    
    subject.onNext("?")
}


// 1
enum MyError: Error {
    case anError
}

// 2
func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, (event.element ?? event.error) ?? event)
}

// 3
example(of: "BehaviorSubject") { // 하나의 초기값으로 시작, 최신 값(.next)만 새로운 subscriber에게 emit // 뷰를 가장 최신의 데이터로 미리 채우기에 용이(유저 프로필 화면)
    // 4
    let subject = BehaviorSubject(value: "Initial value")
    let disposeBag = DisposeBag()
    
    subject.onNext("X")
    
    subject
        .subscribe {
            print(label: "1)", event: $0)
        }
        .disposed(by: disposeBag)
    
    // 1
    subject.onError(MyError.anError)
    
    // 2
    subject
        .subscribe {
            print(label: "2)", event: $0)
        }
        .disposed(by: disposeBag)
}

example(of: "ReplaySubject") { // 버퍼 사이즈를 저장하며, 버퍼 사이즈만큼 새로운 subscriber에게 emit // 최신 데이터 여러 개를 보여주고 싶은 경우(최근 검색)
    // 1
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBag = DisposeBag()
    
    // 2
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
    // 3
    subject
        .subscribe {
            print(label: "1)", event: $0)
        }
        .disposed(by: disposeBag)
    
    subject
        .subscribe {
            print(label: "2)", event: $0)
        }
        .disposed(by: disposeBag)
    
    subject.onNext("4")
    subject.onError(MyError.anError)
//    subject.dispose()
    subject
        .subscribe {
            print(label: "3)", event: $0)
        }
        .disposed(by: disposeBag)
}

example(of: "PublishRelay") { // PublishSubject를 단순히 wrap한 것이며 .next만 가능하고 기능 동일
    let relay = PublishRelay<String>()
    
    let disposeBag = DisposeBag()
    
    relay.accept("Knock knock, anyone home?")
    relay
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    relay.accept("1")
}

example(of: "BehaviorRelay") { // BehaviorSubject를 단순히 wrap한 것이며 .next만 가능하고 기능 동일
    // 1
    let relay = BehaviorRelay(value: "Initial value")
    let disposeBag = DisposeBag()
    
    // 2
    relay.accept("New initial value")
    
    // 3
    relay
        .subscribe {
            print(label: "1)", event: $0)
        }
        .disposed(by: disposeBag)
    
    // 1
    relay.accept("1")
    
    // 2
    relay
        .subscribe {
            print(label: "2)", event: $0)
        }
        .disposed(by: disposeBag)
    
    // 3
    relay.accept("2")
    
    print(relay.value)
}
