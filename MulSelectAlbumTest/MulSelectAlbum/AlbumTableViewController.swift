//
//  AlbumTableViewController.swift
//  MulSelectAlbumTest
//
//  Created by 陈鲲鹏 on 15/3/10.
//  Copyright (c) 2015年 陈鲲鹏. All rights reserved.
//

import UIKit
import AssetsLibrary

class AlbumTableViewController: UIViewController {

    var assetsGroups : NSMutableArray!
    var assetsLibrary : ALAssetsLibrary!
    @IBOutlet weak var tableView: UITableView!

    private var getImageArrayCallBack : ((imageArray:[UIImage])->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的相册"
        
        self.navigationController?.navigationBar.translucent = false
        
        assetsGroups = NSMutableArray()
        assetsLibrary = ALAssetsLibrary()
        
        tableView.registerNib(UINib(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: AlbumTableViewCell.cellID)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        var type : UInt32 = ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
            ALAssetsGroupFaces | ALAssetsGroupPhotoStream | ALAssetsGroupSavedPhotos
        self.assetsLibrary.enumerateGroupsWithTypes(type, usingBlock: { (assetsGroup, stop) -> Void in
            if assetsGroup != nil{
                assetsGroup!.setAssetsFilter(ALAssetsFilter.allPhotos())
                if assetsGroup!.numberOfAssets() > 0  {
                    self.assetsGroups.addObject(assetsGroup!)
                    self.tableView.reloadData()
                }
            }
        }) { (error) -> Void in
            println("Error:\(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: -类方法
extension AlbumTableViewController{
    func getImagesArray(getImageArrayCallBack : ((imageArray:[UIImage])->Void)!){
        self.getImageArrayCallBack = getImageArrayCallBack
    }
}

//MARK: -UITableViewDataSource
extension AlbumTableViewController : UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.assetsGroups.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier(AlbumTableViewCell.cellID) as AlbumTableViewCell
        cell.initData(self.assetsGroups.objectAtIndex(indexPath.row) as ALAssetsGroup)
        return cell
    }
}

//MARK: -UITableViewDelegate
extension AlbumTableViewController : UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return AlbumTableViewCell.cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var photoCollectionViewController = PhotoCollectionViewController(nibName: "PhotoCollectionViewController", bundle: nil)
        photoCollectionViewController.assetsGroup = self.assetsGroups.objectAtIndex(indexPath.row) as ALAssetsGroup
        
        photoCollectionViewController.getImagesArray { (imageArray) -> Void in
            println("second:\(imageArray)")
            self.navigationController?.navigationBarHidden = true
            self.navigationController?.popViewControllerAnimated(false )
            self.getImageArrayCallBack(imageArray: imageArray)
        }
        
        self.navigationController?.pushViewController(photoCollectionViewController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath , animated: true)

    }
}
