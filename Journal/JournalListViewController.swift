import UIKit
import CoreData

class JournalListViewController: UITableViewController {
    
    var journalList = [Journal]()
    var managedObjectContext:NSManagedObjectContext?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var imgs :[UIImage] = [UIImage]()
        //journalList.append(Journal(title:"First Title Test", body:"First Body Test", images:imgs))

        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            managedObjectContext = appDelegate.managedObjectContext
        }
        //println("context??ListView -> \(managedObjectContext)")

        fetchData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        fetchData()
        self.tableView.reloadData()
    }
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of  rows in the section.
        return journalList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("journalCell", forIndexPath: indexPath) as! JournalCell
        
        // Configure the cell...
        
        var selectedJournal = journalList[indexPath.row]
        cell.titleText.text = selectedJournal.title
        //cell.bodyText.text = selectedJournal.body
        
        return cell
    }
    
    func fetchData(){
        journalList = [Journal]()
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
        //println("How Many data fetched? \(journalList.count)")
    }
    
    /*func saveJournal(journal: Journal) {
        journalList.append(journal)
        println("Journal SIze: \(journalList.count) EOL")
        //println("Journal 0 Image size: \(journalList[0].images!.count)")
        self.tableView.reloadData()
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "addJournalSegue")
        {
            var controller = segue.destinationViewController as! AddJournalViewController
            //controller.delegate = self
        }
        if(segue.identifier == "viewJournalSegue")
        {
            var controller = segue.destinationViewController as! ViewJournalController
            let path = tableView.indexPathForSelectedRow()!
            controller.currentJournal = journalList[path.row]
        }
}
}
