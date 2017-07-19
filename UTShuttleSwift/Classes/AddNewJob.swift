//
//  AddNewJob.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 19/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

class AddNewJob: UIView {

    @IBOutlet weak var selectRouteLabel:UILabel!
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
    }
    
    required init?(scheduledJobs: [ScheduledJob]) {
        
        super.init(frame: UIApplication.shared.keyWindow!.frame)
        self.scheduledJobs = scheduledJobs
        
        loadView()
    }
    
    func loadView() {
        let xibView = Bundle.main.loadNibNamed("AddNewJob", owner: self, options: nil)![0] as! UIView
        self.frame = UIApplication.shared.keyWindow!.frame
        xibView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - 10, height: self.frame.size.width - 10)//CGRect(0, 0, self.frame.size.width, self.frame.size.height)
        xibView.center = self.center
        xibView.cornerRadius = 20
        self.addSubview(xibView)
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
    
    func show()
    {
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self)
    }
    
    func hide()
    {
        self.removeFromSuperview()

    }

}
