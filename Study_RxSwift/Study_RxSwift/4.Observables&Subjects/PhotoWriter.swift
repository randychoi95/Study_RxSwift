//
//  PhotoWriter.swift
//  Study_RxSwift
//
//  Created by 최제환 on 2021/03/26.
//

import Foundation
import UIKit
import Photos
import RxSwift

class PhotoWriter {
    enum Errors: Error {
        case couldNotSavePhoto
    }
    
    static func save(_ image: UIImage) -> Single<String> {
        return Single.create { single in
            var savedAssetId: String?
            
            // PHPHotoLibrary는 사용자가 공유하고 있는 photo library를 관리하는 공유 클래스
            PHPhotoLibrary.shared().performChanges {
                // PHAssetChangeRequest를 통해 이미지 수정을 요청
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                savedAssetId = request.placeholderForCreatedAsset?.localIdentifier
            } completionHandler: { success, error in
                DispatchQueue.main.async {
                    if success, let id = savedAssetId {
                        single(.success(id))
                    } else {
                        single(.error(Errors.couldNotSavePhoto))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
}
