//
//  LoadingVC.swift
//  Weather Matters
//
//  Created by Ellen Shin on 6/14/16.
//  Copyright © 2016 Ellen Shin. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.dismissView), name: "finishedLoading", object: nil)
    }
    
    func dismissView() {
        dismissViewControllerAnimated(false, completion: nil)
    }

}
