//
//  ProgressViewController.swift
//  Goals
//
//  Created by Josh Olumese on 7/17/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit
import Charts
import Parse
import RealmSwift

class ProgressViewController: UIViewController {

    @IBOutlet weak var barView: BarChartView!
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    
//    dynamic var date: Date = Date()
//    dynamic var count: Int = Int(0)
//    
//    func save() {
//        do {
//            let realm = try Realm()
//            try realm.write {
//                realm.add(self)
//            }
//        } catch let error as NSError {
//            fatalError(error.localizedDescription)
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
