//
//  ViewController.swift
//  Investing Simulator
//
//  Created by Bryan Lysander on 10/9/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "stock")
        imageView.contentMode = .scaleToFill
    }
}

