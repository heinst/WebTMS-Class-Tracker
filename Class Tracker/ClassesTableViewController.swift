//
//  ClassesTableViewController.swift
//  Class Tracker
//
//  Created by Trevor Heins on 12/21/15.
//  Copyright © 2015 Trevor Heins. All rights reserved.
//

import UIKit
import Kanna
import Alamofire

class ClassesTableViewController: UITableViewController {

    var urlString:String!
    var classes = [String: NSMutableArray]()
    var classNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let queue = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
        Alamofire.request(urlString)
            .response(
                queue: queue,
                responseSerializer: DataRequest.stringResponseSerializer(encoding: String.Encoding.utf8),
                completionHandler: { response in
                    // You are now running on the concurrent `queue` you created earlier.
                    
                    // Validate your JSON response and convert into model objects if necessary
                    if let doc = Kanna.HTML(html: response.result.value!, encoding: String.Encoding.utf8) {
                        
                        self.classes = self.parseColumnFromHtml(doc: doc)
                        
                        self.classNames = [String] (self.classes.keys).sorted()
                        
                        self.tableView.reloadData()
                    }
                    
                    // To update anything on the main thread, just jump back on like so.
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseColumnFromHtml(doc: HTMLDocument) -> [String: NSMutableArray]
    {
        var classesDict = [String: NSMutableArray]()
        for tr in doc.xpath("//*[local-name()=\"tr\" and @class=\"tableHeader\"]/following-sibling::tr[position() < last()]") {
            var tempDict = [String: ClassModel]()
            let trs = tr.xpath(".//td")
            
            //12 if final scheduled, 10 if no final scheduled
            var instructorIndex = 12
            if trs.count == 11 {
                instructorIndex = 10
            }
            
            if let classArray = classesDict[String(format: "%@ %@", trs[0].text!, trs[1].text!)] {
                tempDict[trs[5].text!] = ClassModel(course: String(format: "%@ %@", trs[0].text!, trs[1].text!), instrType: trs[2].text!, section: trs[4].text!, crn: trs[5].text!, url: String(format: "https://duapp2.drexel.edu%@", trs[5].xpath(".//p/a/@href")[0].text!), courseTitle: trs[6].text!, meetingTime:  String(format: "%@ %@", trs[8].text!, trs[9].text!), instructor: trs[instructorIndex].text!)
                classArray.add(tempDict)
            }
            else {
                classesDict[String(format: "%@ %@", trs[0].text!, trs[1].text!)] = NSMutableArray()
                tempDict[trs[5].text!] = ClassModel(course: String(format: "%@ %@", trs[0].text!, trs[1].text!), instrType: trs[2].text!, section: trs[4].text!, crn: trs[5].text!, url: String(format: "https://duapp2.drexel.edu%@", trs[5].xpath(".//p/a/@href")[0].text!), courseTitle: trs[6].text!, meetingTime:  String(format: "%@ %@", trs[8].text!, trs[9].text!), instructor: trs[instructorIndex].text!)
                classesDict[String(format: "%@ %@", trs[0].text!, trs[1].text!)]?.add(tempDict)
            }
        }
        return classesDict
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return classes.keys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath as IndexPath)
        
        cell.textLabel!.text = self.classNames[indexPath.row]
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
