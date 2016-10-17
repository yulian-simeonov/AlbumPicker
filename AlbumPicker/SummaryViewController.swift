//
//  ViewController.swift
//  AlbumPicker
//
//  Created by Yulian Simeonov on 4/1/15.
//  Copyright (c) 2015 YulianMobile. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    
    var albumData: APAlbumEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set Album Image
        albumImage.sd_setImageWithURL(NSURL(string: albumData.albumLargeImageURL))
        albumImage.contentMode = .ScaleAspectFill
        // Set Album Title and Price
        self.titleLabel.text = NSString(format: "Title: %@", albumData.title)
        self.priceLabel.text = NSString(format: "Price: %@", albumData.price)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

