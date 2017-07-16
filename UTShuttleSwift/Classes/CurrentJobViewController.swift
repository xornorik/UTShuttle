//
//  CurrentJobViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 16/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

class CurrentJobViewController: UIViewController {
    
    @IBOutlet weak var tripNoLabel:UILabel!
    @IBOutlet weak var fromLocationLabel:UILabel!
    @IBOutlet weak var toLocationLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var startJobButton:UIButton!
    @IBOutlet weak var previousStopButton:UIButton!
    @IBOutlet weak var currentStopLabel:UILabel!
    @IBOutlet weak var nextStopButton:UIButton!
    @IBOutlet weak var stopsCollectionView:UICollectionView!
    @IBOutlet weak var jobDetailsTableView:UITableView!

    var currentStopIndexPath:IndexPath?
    var noOfNodes = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupVC()
    {
        currentStopIndexPath = IndexPath(item: 0, section: 0)
        nextStopButton.addTarget(self, action: #selector(nextStopButtonTapped), for: .touchUpInside)
        
    }
    /*
     func beginAnimations()
     {
     let fromIndexPath = IndexPath(item: 0, section: 0)
     let toIndexPath = IndexPath(item: 8, section: 0)
     animateToIndexPath(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath, withDuration: 5)
     }
     
     private func animateToIndexPath(fromIndexPath:IndexPath, toIndexPath:IndexPath, withDuration duration:TimeInterval)
     {
     var indexPath = fromIndexPath
     animateCell(indexPath: fromIndexPath, duration: duration) { (success) in
     if indexPath != toIndexPath
     {
     indexPath = IndexPath(item: (indexPath.item + 1), section: 0)
     self.animateToIndexPath(fromIndexPath: indexPath, toIndexPath: toIndexPath,withDuration: duration)
     }
     else
     {
     return
     }
     }
     }
     
     private func animateCell(indexPath:IndexPath, duration:TimeInterval, callback:@escaping (_ success:Bool)->())
     {
     
     guard let cell = testCV.cellForItem(at: indexPath) else {
     print("Cell error at indexPath: \(indexPath)")
     return
     }
     
     self.testCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
     
     drawLineToCenter(cell: cell, duration: duration/3) {
     self.animateNode(cell: cell, duration: duration/3, callback: {
     self.drawLineFromCenter(cell: cell, duration: duration/3, callback: {
     callback(true)
     })
     })
     }
     }

 
 
 
    */
    
    
    
    func nextStopButtonTapped()
    {
        guard currentStopIndexPath?.item != nil else {return}
        let nextStopIndexPath = IndexPath(item: (currentStopIndexPath?.item)! + 1, section: 0)
        guard nextStopIndexPath.item < (noOfNodes - 1) else {return}
        stopsCollectionView.scrollToItem(at: nextStopIndexPath, at: .centeredHorizontally, animated: true)
        
        
        
        let cell = stopsCollectionView.dequeueReusableCell(withReuseIdentifier: "nodeCell", for: currentStopIndexPath!) as! UTSNodeCollectionViewCell//stopsCollectionView.cellForItem(at: currentStopIndexPath!) as! UTSNodeCollectionViewCell
        cell.drawRightConnector(duration: 0.2) { 
            let nextCell = self.stopsCollectionView.dequeueReusableCell(withReuseIdentifier: "nodeCell", for: nextStopIndexPath) as! UTSNodeCollectionViewCell//self.stopsCollectionView.cellForItem(at: nextStopIndexPath) as! UTSNodeCollectionViewCell
            nextCell.drawLeftConnector(duration: 0.2, callback: { 
                nextCell.animateNodeColorChange(duration: 0.2, callback: {
                    self.currentStopIndexPath = nextStopIndexPath
                    self.stopsCollectionView.reloadItems(at: [self.currentStopIndexPath!,IndexPath(item: (self.currentStopIndexPath?.item)! - 1, section: 0)])
                })
            })
        }
    }
}
extension CurrentJobViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noOfNodes
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nodeCell", for: indexPath) as! UTSNodeCollectionViewCell

        print(indexPath)
        switch indexPath.item
        {
        case 0:
            cell.type = .start
            cell.name = "First stop"
        case collectionView.numberOfItems(inSection: 0) - 1:
            cell.type = .end
            cell.name = "Last stop"
        default:
            
            if let currentStop = currentStopIndexPath?.item
            {
                if indexPath.item < currentStop
                {
                    cell.type = .middlePassed
                    cell.name = "middle passed"
                }
                else if indexPath.item == currentStop
                {
                    cell.type = .middleReached
                    cell.name = "middle reached"
                }
                else
                {
                    cell.type = .middle
                    cell.name = "middle stop"
                }
            }
            else
            {
                cell.type = .middle
                cell.name = "middle stop"
            }
        }
        cell.setupCell()

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellCount = noOfNodes
        let cellWidth:CGFloat = 70
        let cellSpacing = 0
        
        let totalCellWidth = cellWidth * CGFloat(cellCount)
        let totalSpacingWidth = cellSpacing * (cellCount - 1)
        
        if totalCellWidth < collectionView.bounds.size.width
        {
            let leftInset = (collectionView.frame.size.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
            let rightInset = leftInset
        
            return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        }
        else
        {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
}
extension CurrentJobViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
