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
    var image = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.4
        authorText.text = author
        authorBio.text = biography
        
    }
    
    
    struct Biography: Codable {
        var AbstractText: String?
        var Image: String?
    }
 
}

