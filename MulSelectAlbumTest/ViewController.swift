//
//  ViewController.swift
//  MulSelectAlbumTest
//
//  Created by 陈鲲鹏 on 15/3/10.
//  Copyright (c) 2015年 陈鲲鹏. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func click(sender: AnyObject) {
        var controller = AlbumTableViewController(nibName:"AlbumTableViewController",bundle:nil)
        controller.maxCount = 3
        controller.getImagesArray { (imageArray) -> Void in
            println("first:\(imageArray)")
            self.imageView.image = imageArray[0] as UIImage
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

