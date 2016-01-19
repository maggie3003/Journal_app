//
//  ViewJournalController.swift
//  Journal
//
//  Created by Meiqi You on 21/08/2015.
//  Copyright (c) 2015 Meiqi You. All rights reserved.
//

import UIKit
import MapKit


class ViewJournalController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate {

    var currentJournal:Journal?
    
    @IBOutlet weak var titleLabel: UILabel!
   
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageCollection: UICollectionView!
    
    @IBOutlet weak var bodyText: UITextView!
   
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var locationManager = CLLocationManager()
    
   
    var imgs:[UIImage]?
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        print("IN VIEW PAGE: \(currentJournal)")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool){
        
        super.viewWillAppear(animated)
        titleLabel.text=currentJournal?.title
        print("\(currentJournal!.title) -->latitude test")
        //bodyLabel.text=currentJournal?.body
        bodyText.text=currentJournal?.body
        //timeLabel.text=currentJournal?.time
        timeLabel.text = currentJournal?.getTimeAsString()
        //imgs = currentJournal?.images
        imgs = currentJournal?.getImages()
        print("IN IN Controller: SIZE: \(imgs?.count)")
        
        imageCollection.delegate = self
        imageCollection.dataSource = self
        
        //place marker
        var annotation = JournalAnnotation()
        //annotation.coordinate = CLLocationCoordinate2D(latitude: (currentJournal!.latitude as NSString).doubleValue, longitude: (currentJournal!.longitude as NSString).doubleValue)
        //println("\(currentJournal!.latitude) -->latitude test")
       // annotation.title = currentJournal?.title
        
        annotation = JournalAnnotation(title: currentJournal!.title,coordinate: CLLocationCoordinate2D(latitude: (currentJournal!.latitude as NSString).doubleValue, longitude: (currentJournal!.longitude as NSString).doubleValue))

        
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = annotation.coordinate

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section:Int)->Int{
        print(imgs!.count)
        return imgs!.count

    }
    
    func collectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("viewImageCell", forIndexPath: indexPath) as! viewImageCell
        print("\(indexPath.row) indexpath row", terminator: "")
        
        cell.image.image = imgs?[indexPath.row]
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
