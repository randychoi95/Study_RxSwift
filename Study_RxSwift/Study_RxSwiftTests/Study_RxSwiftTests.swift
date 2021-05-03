//
//  Study_RxSwiftTests.swift
//  Study_RxSwiftTests
//
//  Created by 최제환 on 2021/03/22.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Study_RxSwift

class Study_RxSwiftTests: XCTestCase {
    var viewModel: ViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUp() {
        super.setUp()
        
        viewModel = ViewModel()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }
    
    func testColorIsRedWhenHexStringIsFF0000_async() {
        let disposeBag = DisposeBag()
        
        let expect = expectation(description: #function)
        
        let expectedColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        var result: UIColor!
        
        viewModel.color.asObservable()
            .skip(1)
            .subscribe(onNext: {
                result = $0
                expect.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.hexString.accept("#ff0000")
        
        waitForExpectations(timeout: 1.0) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            
            XCTAssertEqual(expectedColor, result)
        }
    }
    
    func testColorIsRedWhenHexStringIsFF0000() throws {
        let colorObservable = viewModel.color.asObservable().subscribeOn(scheduler)
        
        viewModel.hexString.accept("#ff0000")
        
        XCTAssertEqual(try colorObservable.toBlocking(timeout: 1.0).first(), .red)
    }
    
    func testRgbIs010WhenHexStringIs00FF00() throws {
        let rgbObservable = viewModel.rgb.asObservable().subscribeOn(scheduler)
        
        viewModel.hexString.accept("#00ff00")
        
        let result = try rgbObservable.toBlocking().first()!
        
        XCTAssertEqual(0*255, result.0)
        XCTAssertEqual(1*255, result.1)
        XCTAssertEqual(0*255, result.2)
    }
    
    func testColorNameIsRayWenderlichGreenWhenHexStringIs006636() throws {
        let colorNameObservable = viewModel.colorName.asObservable().subscribeOn(scheduler)
        
        viewModel.hexString.accept("#006636")
        
        XCTAssertEqual("rayWenderlichGreen", try colorNameObservable.toBlocking().first()!)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
