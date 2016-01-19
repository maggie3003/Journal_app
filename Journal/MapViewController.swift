//
//  MapViewController.swift
//  Journal
//
//  Created by Meiqi You on 4/09/2015.
//  Copyright (c) 2015 Meiqi You. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var locationManager = CLLocationManager()
    var journalList = [Journal]()
    var managedObjectContext: NSManagedObjectContext?
    var jtitle = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set initial location at Melbourne
        let initialLocation = CLLocation(latitude: -37.8131869, longitude: 144.9629796)
        //set display size
        /*let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation){
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }*/
        //centerMapOnLocation(initialLocation)
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.distanceFilter = 1.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation();
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            managedObjectContext = appDelegate.managedObjectContext
        }
        //println("context??ListView -> \(managedObjectContext)")
        
        fetchData()
        
        //put markers...
        
        //var annotation = MKPointAnnotation()
        
        for n in journalList
        {

            mapView.addAnnotation(JournalAnnotation(title:n.title,coordinate: CLLocationCoordinate2D(latitude: (n.latitude as NSString).doubleValue, longitude: (n.longitude as NSString).doubleValue)))
        }

        
        mapView.delegate = self
    }
    
    func fetchData(){
        //journalList = [Journal]()
        let fetch = NSFetchRequest(entityName:"Journal")
        let dataSort = NSSortDescriptor(key:"time",ascending:false)
        fetch.sortDescriptors = [dataSort]
        var fetchError:NSError?
        //println("context??InFetch -> \(managedObjectContext)")
        
        if let fetchResults = managedObjectContext?.executeFetchRequest(fetch, error: &fetchError) as? [Journal]{
            for journal in fetchResults{
                println("Fecthed ->  \(journal.title)")
                journalList.append(journal)
            }
        }
        else{
            println("Fetch failed: \(fetchError),\(fetchError!.userInfo)")
        }
        println("How Many data fetched in MapViewController? \(journalList.count)")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let identifier = "JournalAnnotation"
        if annotation.isKindOfClass(JournalAnnotation.self){
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            if annotationView == nil{
                annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView.enabled = true
                annotationView.canShowCallout = true
                
                let btn = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
                annotationView.rightCalloutAccessoryView = btn
            }else{
                annotationView.annotation = annotation
            }
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        let journalAnno = view.annotation as! JournalAnnotation
        let title = journalAnno.title
        jtitle = title
        //let ac = UIAlertController(title: title, message: "testMessage", preferredStyle: .Alert)
        //ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        //presentViewController(ac,animated:true, completion:nil)
        
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("viewJournal") as! ViewJournalController
        
        var journalSelected:Journal
        
        for j in journalList{
            var count:Int = 0
            if count < journalList.count && j.title == journalList[count].title {
                journalSelected = journalList[count]
                println("Selected Journal is \(journalSelected)")
                nextViewController.currentJournal = journalSelected
            }
            else if count == journalList.count{
            }
        }
        
        println("Next Current Journa: \(nextViewController.currentJournal)")
        
        self.presentViewController(nextViewController,animated: true,completion:nil)
        
        
      //  performSegueWithIdentifier("mapToJournalSegue", sender: self)
    }
    
   /* override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         var journalSelected: Journal
        
        if segue.identifier == "mapToJournalSegue"{
           
            var controller = segue.destinationViewController as! ViewJournalController
            for j in journalList{
                var count:Int = 0
                    if count < journalList.count && j.title == journalList[count].title {
                        journalSelected = journalList[count]
                        //println("Selected Journal is \(journalSelected)")
                         controller.currentJournal? = journalSelected
                    }
                    else if count == journalList.count{
                        
                }
                
            }
        }
        
    }*/
}
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


