//
//  AllCategoriesViewController.swift
//  Goals
//
//  Created by Isabella Teng on 8/1/17.
//  Copyright © 2017 Isabella Teng. All rights reserved.
//

import UIKit

class AllCategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CategoryCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allCategories: [String] = ["Education", "Health", "Fun", "Money", "Spiritual", "Other"] //other is just a filler for aesthetics

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundView = UIImageView(image: UIImage(named: "backgroundimg"))
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func categoryCell(_ categoryCell: CategoryCell, didTap categoryName: String) {
        performSegue(withIdentifier: "categorytoGoalsSegue", sender: categoryName)
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.categoryLabel.text = allCategories[indexPath.item]
        cell.delegate = self
        
        return cell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "categorytoGoalsSegue") {
            let vc = segue.destination as! Category_sGoalsViewController
            vc.goalCategory = sender as! String
        }
    }
    

}
