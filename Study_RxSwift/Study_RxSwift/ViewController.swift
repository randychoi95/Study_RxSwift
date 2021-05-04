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
    
    @IBAction func goToChapter12(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Wundercast", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WundercastViewController") as! WundercastViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func goToChapter13(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Wundercast2", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WundercastViewController2") as! WundercastViewController2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func goToChapter14(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Wundercast3", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WundercastViewController3") as! WundercastViewController3
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func goToChapter17(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "giphy", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTableViewController") as! MainTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

