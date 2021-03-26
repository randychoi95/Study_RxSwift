//
//  UIViewController+Alert.swift
//  Study_RxSwift
//
//  Created by 최제환 on 2021/03/26.
//

import Foundation
import UIKit
import RxSwift

extension UIViewController {
    func alert(_ title: String, text: String?) -> Completable {
        return Completable.create { [weak self] completable in
            let alertVC = UIAlertController.init(title: title, message: text, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: "Close", style: .cancel, handler: { _ in
                completable(.completed)
            }))
            self?.present(alertVC, animated: true, completion: nil)
            return Disposables.create {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
