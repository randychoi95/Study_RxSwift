//
//  ObservablesAndSubjectsViewController.swift
//  Study_RxSwift
//
//  Created by 최제환 on 2021/03/26.
//

import UIKit
import RxSwift
import RxRelay

class ObservablesAndSubjectsViewController: UIViewController {
    
    private let bag = DisposeBag()
    private let images = BehaviorRelay<[UIImage]>(value: [])
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var itemAdd: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // BehaviorRelay객체에 구독 요청
        images
            .subscribe(onNext: { [weak imagePreview] photos in
                guard let preview = imagePreview else {return}
                preview.image = photos.collage(size: preview.frame.size)
            })
            .disposed(by: bag)
        
        images
            .subscribe(onNext: { [weak self] photos in
                self?.updateUI(photos: photos)
            })
            .disposed(by: bag)
    }
    
    @IBAction func actionClear() {
        images.accept([])
    }
    
    @IBAction func actionSave() {
        guard let image = imagePreview.image else { return }
        
        PhotoWriter.save(image)
            .subscribe { [weak self] id in
                self?.showMessage("Saved with id: \(id)")
                self?.actionClear()
            } onError: { [weak self] error in
                self?.showMessage("Error", description: error.localizedDescription)
            }
            .disposed(by: bag)

    }
    
    @IBAction func actionAdd() {
        //        let newImages = images.value + [UIImage(named: "IMG_1907.jpg")!]
        //        images.accept(newImages)
        
        let photosViewController = storyboard!.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
        
        photosViewController.selectedPhotos
            .subscribe(onNext: { [weak self] newImage in
                guard let images = self?.images else { return }
                images.accept(images.value + [newImage])
            },
            onDisposed: {
                print("Completed photo selection")
            }
            )
            .disposed(by: bag)
        
        navigationController!.pushViewController(photosViewController, animated: true)
    }
    
    func showMessage(_ title: String, description: String? = nil) {
        alert(title, text: description)
            .subscribe()
            .disposed(by: bag)
    }
    
    private func updateUI(photos: [UIImage]) {
        buttonSave.isEnabled = photos.count > 0 && photos.count % 2 == 0
        
        buttonClear.isEnabled = photos.count > 0
        itemAdd.isEnabled = photos.count < 6
        title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
    }
}
