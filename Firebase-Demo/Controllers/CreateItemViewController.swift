//
//  CreateItemViewController.swift
//  Firebase-Demo
//
//  Created by Kelby Mittan on 3/2/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class CreateItemViewController: UIViewController {

    @IBOutlet var itemNameTextField: UITextField!
    
    @IBOutlet var itemPriceTextField: UITextField!
    
    private var category: Category
    
    init?(coder: NSCoder, category: Category) {
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func sellButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
}
