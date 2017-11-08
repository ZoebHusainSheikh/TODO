//
//  BaseViewController.swift
//  TodoApp
//
//  Created by Best Peers on 07/11/17.
//  Copyright © 2017 Best Peers. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
