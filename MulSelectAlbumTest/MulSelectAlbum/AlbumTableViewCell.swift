//
//  AlbumTableViewCell.swift
//  MulSelectAlbumTest
//
//  Created by 陈鲲鹏 on 15/3/10.
//  Copyright (c) 2015年 陈鲲鹏. All rights reserved.
//

import UIKit
import AssetsLibrary

class AlbumTableViewCell: UITableViewCell {


    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var count: UILabel!
    
    class var cellID : String{
        return "AlbumTableViewCell"
    }
    
    class var cellHeight : CGFloat{
        return 80
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension AlbumTableViewCell {

    func initData(assetsGroup:ALAssetsGroup){
        albumImageView.image = UIImage(CGImage: assetsGroup.posterImage().takeUnretainedValue())//UIImage(CGImage: assetsGroup.posterImage())
        title.text = assetsGroup.valueForProperty(ALAssetsGroupPropertyName) as? String
        count.text = "(" + "\(assetsGroup.numberOfAssets())" + ")"

    }
}
