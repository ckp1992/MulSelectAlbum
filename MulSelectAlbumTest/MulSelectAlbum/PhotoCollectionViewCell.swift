//
//  PhotoCollectionViewCell.swift
//  MulSelectAlbumTest
//
//  Created by 陈鲲鹏 on 15/3/10.
//  Copyright (c) 2015年 陈鲲鹏. All rights reserved.
//

import UIKit
import AssetsLibrary

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var selectImage: UIImageView!
    
    class var cellID : String{
        return "PhotoCollectionViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension PhotoCollectionViewCell{
    func setData(asset:ALAsset){
        var thum : CGImage? = asset.thumbnail().takeUnretainedValue()
        var image = UIImage(CGImage: thum)
        photoImage.image = image

    }
    func selectState(){
        photoImage.alpha = 0.4
        selectImage.hidden = false
    }
    func deselectState(){
        photoImage.alpha = 1;
        selectImage.hidden = true
    }
}
