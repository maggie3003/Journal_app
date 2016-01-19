//
//  AddJournalViewController.swift
//  Journal
//
//  Created by Meiqi You on 21/08/2015.
//  Copyright (c) 2015 Meiqi You. All rights reserved.
//

import UIKit
//import Swift
import Photos
import CoreLocation
import CoreData

/*protocol AddJournalControllerDelegate{
    func saveJournal(journal: Journal)
    //func addPic()
}*/

let albumName = "Journal Pics"


class AddJournalViewController: UIViewController,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var bodyTextBig: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var time: String = ""
    var dateFormatter: NSDateFormatter = NSDateFormatter()
    
    var location:CLLocation! = CLLocation()
    var locationManager:CLLocationManager! = CLLocationManager()
    var longitude: String = ""
    var latitude: String = ""
    
    //var testimg:UIImage?
    let reuseIdentifier = "ImageCell"
   // var delegate: AddJournalControllerDelegate?
    
    var albumFound : Bool = false
    var assetCollection: PHAssetCollection!
    var photoAsset: PHFetchResult!
    var assetThumbnailSize:CGSize!
    
    var managedObjectContext: NSManagedObjectContext?
    
    @IBOutlet weak var ccollectionView: UICollectionView!
    
    @IBOutlet weak var scroller: UIScrollView!
    var imgs:[UIImage]? = [UIImage]()

    
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
            scroller.userInteractionEnabled = true
            scroller.contentSize = CGSizeMake(400,480)
            
            
           // imgs = [UIImage]()
            
            //prepare for image collections
            ccollectionView?.dataSource=self
            ccollectionView?.delegate=self
            ccollectionView?.bounces=true
            
           //prepare time
            dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.timeZone = NSTimeZone()
           
            //location
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
                managedObjectContext = appDelegate.managedObjectContext
            }
            print("context??AtTOp -> \(managedObjectContext)")

            
        //check if folder exists
        /*let fetchOptions = PHFetchOptions()
            fetchOptions.predicate=NSPredicate(format: "title = %@",albumName)
            let collection:PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
            
            if let first_Obj:AnyObject = collection.firstObject{
                //found the album
                self.albumFound = true
                self.assetCollection = first_Obj as! PHAssetCollection
            }else{
                //Album placeholder for the asset collection, used to reference collection in completion handler
                var albumPlaceholder:PHObjectPlaceholder!
                //create the folder
                NSLog("\nFolder \"%@\" does not exist\nCreating now...", albumName)
                PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                    let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(albumName)
                    albumPlaceholder = request.placeholderForCreatedAssetCollection
                    },
                    completionHandler: {(success:Bool, error:NSError!)in
                        if(success){
                            println("Successfully created folder")
                            self.albumFound = true
                            if let collection = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([albumPlaceholder.localIdentifier], options: nil){
                                self.assetCollection = collection.firstObject as! PHAssetCollection
                            }
                        }else{
                            println("Error creating folder")
                            self.albumFound = false
                        }
                })
            }*/

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "viewFullSizeSegue"){
            if let controller:ViewPictureController = segue.destinationViewController as? ViewPictureController{
                if let cell = sender as? UICollectionViewCell{
                    if let indexPath: NSIndexPath = self.ccollectionView?.indexPathForCell(cell){
                       controller.index = indexPath.item
                        controller.photosAsset = self.photoAsset
                        controller.assetCollection = self.assetCollection
                    }
                }
            }
        }
    }

    //get location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let latestLocation: AnyObject = locations[locations.count - 1]
        
        location = latestLocation as! CLLocation
        latitude = location.coordinate.latitude.description
        longitude = location.coordinate.longitude.description
        print("Latitude: \(latitude), Longtitude: \(longitude)")
        
    }
    
    func locationManager(manager: CLLocationManager,didFailWithError error: NSError){
        
    }
    
    //add pictures
    @IBAction func addPicture(sender: AnyObject) {
        let controller = UIImagePickerController()
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            controller.sourceType=UIImagePickerControllerSourceType.Camera
        }
        else{
            controller.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        }
        controller.allowsEditing=false
        controller.delegate = self
        
        self.presentViewController(controller,animated:true,completion:nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //imageView.image = image
        //testimg = image
        //ccollectionView!.reloadData()
        //self.collectionView.reloadInputViews()
        imgs?.append(image)
        ccollectionView.reloadData()
        self.dismissViewControllerAnimated(true, completion:nil)
        
    }
   
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //show images in collectionView
    func collectionView(collectionView: UICollectionView,numberOfItemsInSection section:Int)->Int{
        /*var count: Int = 1
        if self.imageView != nil{
            count = self.photoAsset.count
        }*/
        return imgs!.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    
    
    /*func collectionView(collectionView: UICollectionView,cellForItemAtIndexPath indexPath: NSIndexPath)->UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! imageCell
        cell.imageView.image = imgs[indexPath.row]
       /*
        let asset:PHAsset = self.photoAsset[indexPath.item] as! PHAsset
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: self.assetThumbnailSize, contentMode: .AspectFill, options: nil, resultHandler: {(result, info)in cell.setThumbnailImage(result)
        })*/
        //cell.imageView.image=testimg
        return cell
    }*/
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! imageCell
        print(indexPath.row, terminator: "")
            cell.imageView.image=imgs?[indexPath.row]
        return cell
    }
   /*
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!,minimumSpacingForSectionAtIndex section:Int)->CGFloat{
        return 4
    }
    
    func collectionView(collectionView:UICollectionView!,layout collectionViewLayout:UICollectionViewLayout!,minimumInteritemSpacingForSectionAtIndex section:Int)->CGFloat{
        return 1
    }*/
    
    @IBAction func cancelJournal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveJournal(sender: AnyObject) {
        //time = dateFormatter.stringFromDate(NSDate())
        //var journal:Journal = Journal()
        print("context?? -> \(managedObjectContext)")
        let journal = NSEntityDescription.insertNewObjectForEntityForName("Journal", inManagedObjectContext: managedObjectContext!) as? Journal
        journal!.title = titleText.text!
        journal!.body = bodyTextBig.text
        //journal.getTimeAsString()
        journal!.time = NSDate()
        journal!.setImageData(imgs!)
        journal!.longitude = longitude
        journal!.latitude = latitude
        
        //var journal = Journal(title: titleText.text,body:bodyTextBig.text,images:imgs,time:time,longitude:longitude,latitude:latitude)
        print("\(longitude) , \(latitude)", terminator: "")
        print("Imgs size: \(imgs!.count)", terminator: "")
        //delegate?.saveJournal(journal!)
        
        var error: NSError? = nil
        
        do {
            try managedObjectContext?.save()
        } catch let error1 as NSError {
            error = error1
        }
        if (error != nil)
        {
            print("could not save :\(error), \(error?.userInfo)")
        }
        
          self.dismissViewControllerAnimated(true, completion: nil)
        }
    
       
    
        // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   // override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
   // }
    

}
