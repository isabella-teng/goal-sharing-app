//
//  PartnersViewController.swift
//  Goals
//
//  Created by Gerardo Parra on 8/8/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

class PartnersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var partners: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180
        
        partners = [ [ "username": "zuck", "goalTitle": "Connect the world", "streak": 1, "chartData": [5, 4, 5, 3, 1, 0, 1] ],
                    [ "username": "anthonyrodari", "goalTitle": "Meet Zuck", "streak": 0, "chartData": [2, 3, 5, 4, 3, 6, 6] ],
                    [ "username": "nataliavillarman", "goalTitle": "Get a return offer", "streak": 10, "chartData": [2, 1, 3, 3, 5, 0, 7] ] ]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartnerCell") as! PartnerCell
        
        cell.partnerInfo = partners[indexPath.row]
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
