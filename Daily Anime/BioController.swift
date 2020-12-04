//
//  BioController.swift
//  Daily Quote
//
//  Created by Siddhesvar Kannan on 8/3/20.
//  Copyright © 2020 Siddhesvar Kannan. All rights reserved.
//

import UIKit

class BioController: UIViewController {

    @IBOutlet weak var authorText: UILabel!
    //@IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorBio: UILabel!
    
    var author = ""
    var biography = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorText.text = author
        authorBio.text = biography
    }
 
}

