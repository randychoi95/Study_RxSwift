import UIKit
import RxSwift

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

example(of: "never") {
    let observable = Observable<Any>.never()
    // 1
    let disposeBag = DisposeBag()
    
    observable
        .debug("never")
        //2
        .do(onSubscribe: { // 일단 실행-subscribe()이 발생된지 알 수 있음
            print("onSubscribe")
        })
        .subscribe(
            onNext: { element in
                print(element)
            },
            onCompleted: {
                print("Completed")
            },
            onDisposed: {
                print("Disposed")
            }
        )
        .disposed(by: disposeBag)
}
