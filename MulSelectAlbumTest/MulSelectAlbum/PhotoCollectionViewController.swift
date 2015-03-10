//
//  PhotoCollectionViewController.swift
//  MulSelectAlbumTest
//
//  Created by 陈鲲鹏 on 15/3/10.
//  Copyright (c) 2015年 陈鲲鹏. All rights reserved.
//

import UIKit
import AssetsLibrary

class PhotoCollectionViewController: UIViewController {

    var assets : NSMutableArray!
    var imageArray : NSMutableArray!
    var assetsGroup : ALAssetsGroup!
    
    private var getImageArrayCallBack : ((imageArray:[UIImage])->Void)!
    
    let MAX_SELECT_COUNT = 5
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择照片"
        assets = NSMutableArray()
        imageArray = NSMutableArray()
        
        collectionView.registerNib(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PhotoCollectionViewCell.cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
            collectionView.allowsMultipleSelection = true
        var categoryFlowLayout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as UICollectionViewFlowLayout
        var width = CGFloat( UIScreen.mainScreen().bounds.width - 2 * 5 ) / 4
        var height = width
        categoryFlowLayout.itemSize = CGSizeMake( width,height)
        categoryFlowLayout.minimumInteritemSpacing = 2
        categoryFlowLayout.minimumLineSpacing = 2
        
        var doneBtn = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Bordered, target: self, action: "done")
        self.navigationItem.rightBarButtonItem = doneBtn;
        
        reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - 类方法
extension PhotoCollectionViewController{
    func done(){
        //返回高清大图
        var imageArray = [UIImage]()
        for indexItem in collectionView.indexPathsForSelectedItems() {
            var indexPath = indexItem as NSIndexPath
            var resultAsset : ALAsset = self.assets.objectAtIndex(indexPath.row) as ALAsset
            var representation : ALAssetRepresentation = resultAsset.defaultRepresentation()
            var resultImageRef : CGImageRef = representation.fullResolutionImage().takeUnretainedValue()
            var resultImage : UIImage = UIImage(CGImage: resultImageRef)!
            imageArray.append(resultImage)
        }
        var index = self.navigationController?.viewControllers.count
        self.navigationController?.viewControllers.removeAtIndex(index! - 2)
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.popViewControllerAnimated(true )

        self.getImageArrayCallBack(imageArray: imageArray)
    }
    
    func getImagesArray(getImageArrayCallBack : ((imageArray:[UIImage])->Void)!){
        self.getImageArrayCallBack = getImageArrayCallBack
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoCollectionViewController : UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.assets.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell: PhotoCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionViewCell.cellID, forIndexPath:indexPath) as PhotoCollectionViewCell

        for indexItem in collectionView.indexPathsForSelectedItems() {
            var index = indexItem as NSIndexPath
            if indexPath.row == index.row {
                cell.selectState()
                break
            }else{
                cell.deselectState()
            }
        }

        cell.setData(self.assets.objectAtIndex(indexPath.row) as ALAsset)
        return cell
    }
}
// MARK: - UICollectionViewDelegate
extension PhotoCollectionViewController : UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return collectionView.indexPathsForSelectedItems().count < MAX_SELECT_COUNT
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as PhotoCollectionViewCell
        cell.selectState()
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as PhotoCollectionViewCell
        cell.deselectState()
    }
}

// MARK: - 类方法
extension PhotoCollectionViewController {
    func reloadData() {
        self.assetsGroup.enumerateAssetsUsingBlock { (result, index, stop) -> Void in
            if result != nil {
                self.assets.addObject(result)
                self.collectionView.reloadData()
            }
        }
    }
}