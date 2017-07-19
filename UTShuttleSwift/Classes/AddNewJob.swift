//
//  AddNewJob.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 19/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import DropDown

class AddNewJob: UIView {

    @IBOutlet weak var selectRouteButton:UIButton!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var isRecurringButton:UIButton!
    
    @IBOutlet weak var isMondayButton:UIButton!
    @IBOutlet weak var isTuesdayButton:UIButton!
    @IBOutlet weak var isWednesdayButton:UIButton!
    @IBOutlet weak var isThursdayButton:UIButton!
    @IBOutlet weak var isFridayButton:UIButton!
    @IBOutlet weak var isSaturdayButton:UIButton!
    @IBOutlet weak var isSundayButton:UIButton!
    
    @IBOutlet weak var saveButton:UIButton!
    @IBOutlet weak var cancelButton:UIButton!
    
    var overlayView:UIView?
    var dialogView:UIView?
    var saveButtonCallback: (()->())?
    
    var scheduledJobs:[ScheduledJob]?
    
    var isMonday = false
    var isTuesday = false
    var isWednesday = false
    var isThrusday = false
    var isFriday = false
    var isSaturday = false
    var isSunday = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
        setupView()
    }
    
    required init?(scheduledJobs: [ScheduledJob]) {
        
        super.init(frame: UIApplication.shared.keyWindow!.frame)
        self.scheduledJobs = scheduledJobs
        
        loadView()
        setupView()
    }
    
    func loadView() {
        dialogView = Bundle.main.loadNibNamed("AddNewJob", owner: self, options: nil)![0] as? UIView
        self.frame = UIApplication.shared.keyWindow!.frame
        dialogView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - 30, height: (self.frame.size.width - 30)*(5/6))//CGRect(0, 0, self.frame.size.width, self.frame.size.height)
        dialogView?.center = self.center
        dialogView?.cornerRadius = 20
        self.addSubview(dialogView!)
    }
    
    func setupView()
    {
        self.selectRouteButton.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    
    func weekButtonToggle(sender:UIButton)
    {
        switch sender.tag {
        case 101:
            break
        case 102:
            break
        case 103:
            break
        case 104:
            break
        case 105:
            break
        case 106:
            break
        case 107:
            break
        default:
            print("Exhaustive")
        }
    }
    
    func showDropDown()
    {
        let dropDown = DropDown()
        dropDown.anchorView = selectRouteButton
        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectRouteButton.setTitle(item, for: .normal)
            dropDown.hide()
        }
    }
    
    func show()
    {
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self)
        
        overlayView = UIView(frame: self.frame)
        overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        let TGR = UITapGestureRecognizer(target: self, action: #selector(hide))
        overlayView?.addGestureRecognizer(TGR)
        self.dialogView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

        self.addSubview(overlayView!)
        self.bringSubview(toFront: dialogView!)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.dialogView?.transform = CGAffineTransform(scaleX: 1, y: 1)

        }) { (true) in
        }
    }
    
    func hide()
    {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.dialogView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (true) in
            self.overlayView?.removeFromSuperview()
            self.removeFromSuperview()
        }
    }

}
