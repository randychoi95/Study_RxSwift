import UIKit
import RxSwift

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

example(of: "just, of, from") {
    let one = 1
    let two = 2
    let three = 3
    
    // 오직 하나의 요소를 포함하는 sequence 생성
    let observable = Observable<Int>.just(one)
    // 타입추론을 이용하며 sequence 생성
    let observable2 = Observable.of(one, two, three) // 배열이 아닌 다중요소
    let observable3 = Observable.of([one, two, three]) // 단일요소인 배열 == just
    // 오직 array타입만 처리하며 각 요소들을 하나씩 emit
    let observable4 = Observable.from([one, two, three])
}

example(of: "subscribe") {
    let one = 1
    let two = 2
    let three = 3
    
    let observable = Observable.of(one, two, three)
    observable.subscribe { event in
        print(event)
    }
}

example(of: "empty") {
    let observable = Observable<Void>.empty()
    observable.subscribe (
        //1
        onNext: { element in
            print(element)
        },
        
        //2
        onCompleted: {
            print("Completed")
        }
    )
}

example(of: "never") {
    let observable = Observable<Void>.never()
    
    observable.subscribe { element in
        print(element)
    } onCompleted: {
        print("Completed")
    }
}

example(of: "range") {
    //1
    let observable = Observable<Int>.range(start: 1, count: 10)
    
    observable
        .subscribe(onNext: { i in
            //2
            let n = Double(i)
            
            let fibonacci = Int(
                ((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded()
            )
            print(fibonacci)
        })
}

example(of: "dispose") {
    //1
    let obserable = Observable.of("A","B","C")
    
    //2
    let subscription = obserable.subscribe { event in
        //3
        print(event)
    }
    subscription.dispose()
}

example(of: "DisposeBag") {
    //1
    let disposeBag = DisposeBag()
    
    //2
    Observable.of("A","B","C")
        .subscribe { //3
            print($0)
        }
        .disposed(by: disposeBag) //4
}

example(of: "create") {
    enum MyError: Error {
        case anError
    }
    
    let disposeBag = DisposeBag()
    
    Observable<String>.create { observer in
        //1
        observer.onNext("1")
        
//        observer.onError(MyError.anError)
        
        //2
//        observer.onCompleted()
        
        //3
        observer.onNext("?")
        
        //4
        return Disposables.create()
    }
    .subscribe(onNext: {print($0)}, onError: {print($0)}, onCompleted: {print("Completed")}, onDisposed: {print("Disposed")})
//    .disposed(by: disposeBag)
}

example(of: "deferred") {
    let disposeBag = DisposeBag()
    
    //1
    var flip = false
    
    //2
    let factory: Observable<Int> = Observable.deferred {
        //3
        flip.toggle()
        
        //4
        if flip {
            return Observable.of(1,2,3)
        } else {
            return Observable.of(4,5,6)
        }
    }
    
    for _ in 0...3 {
        factory.subscribe(onNext: {
            print($0, terminator: "")
        })
        .disposed(by: disposeBag)
        print()
    }
}

example(of: "Single") { // 성공 or 실패를 따지는 one-time작업에 적합(파일 다운로드, 디스크 로딩)
    //1
    let disposeBag = DisposeBag()
    
    //2
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    //3
    func loadText(from name: String) -> Single<String> {
        //4
        return Single.create { single in
            //1
            let disposable = Disposables.create()
            
            //2
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                single(.error(FileReadError.fileNotFound))
                return disposable
            }
            
            //3
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.error(FileReadError.unreadable))
                return disposable
            }
            
            //4
            guard let contents = String(data: data, encoding: .utf8) else {
                single(.error(FileReadError.encodingFailed))
                return disposable
            }
            
            //5
            single(.success(contents))
            return disposable
        }
    }
    
    //1
    loadText(from: "Copyright")
    //2
        .subscribe {
            switch $0 {
            case .success(let string):
                print(string)
            case .error(let error):
                print(error)
            }
        }
        .disposed(by: disposeBag)
}
