import UIKit
import RxSwift
import RxRelay

public func example(of description: String,
                    action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

example(of: "BehaviorRelay") {
  enum UserSession {
    case loggedIn, loggedOut
  }
  
  enum LoginError: Error {
    case invalidCredentials
  }
  
  let disposeBag = DisposeBag()
  
  // Create userSession BehaviorRelay of type UserSession with initial value of .loggedOut
    let relay = BehaviorRelay.init(value: UserSession.loggedOut)

  // Subscribe to receive next events from userSession
    relay
        .subscribe(onNext: {
            print("userSession changed:",$0)
        })
        .disposed(by: disposeBag)
  
  func logInWith(username: String, password: String, completion: (Error?) -> Void) {
    guard username == "johnny@appleseed.com",
          password == "appleseed" else {
      completion(LoginError.invalidCredentials)
      return
    }
    
    // Update userSession
    relay.accept(.loggedIn)
  }
  
  func logOut() {
    // Update userSession
    relay.accept(.loggedOut)
  }
  
  func performActionRequiringLoggedInUser(_ action: () -> Void) {
    // Ensure that userSession is loggedIn and then execute action()
    guard relay.value == .loggedIn else {
        print("You can't do that")
        return
    }
    
    action()
  }
  
  for i in 1...2 {
    let password = i % 2 == 0 ? "appleseed" : "password"
    
    logInWith(username: "johnny@appleseed.com", password: password) { error in
      guard error == nil else {
        print(error!)
        return
      }
      
      print("User logged in.")
    }
    
    performActionRequiringLoggedInUser {
      print("Successfully did something only a logged in user can do.")
    }
  }
}
