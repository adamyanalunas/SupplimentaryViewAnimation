//
//  DetailTableViewController.swift
//  SupplimentaryViewAnimation
//
//  Created by Adam Yanalunas on 6/15/16.
//  Copyright © 2016 Adam Yanalunas. All rights reserved.
//

import Foundation
import UIKit

class DetailTableViewController: UITableViewController {
    weak var detailController:DetailController?
    
    let rows:Int = 20
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DetailTableViewCell.reuseID, forIndexPath: indexPath)
        
        cell.textLabel?.text = "Cell \(indexPath.row)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        detailController?.rowSelected(indexPath)
    }
}