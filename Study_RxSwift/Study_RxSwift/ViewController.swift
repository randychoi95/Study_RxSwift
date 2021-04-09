//
//  ViewController.swift
//  Study_RxSwift
//
//  Created by 최제환 on 2021/03/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func goToChapter4(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ObservablesAndSubjects", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ObservablesAndSubjectsViewController") as! ObservablesAndSubjectsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToChapter8(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "GitFeed", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ActivityController") as! ActivityController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToChapter10(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "OurPlanet", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

