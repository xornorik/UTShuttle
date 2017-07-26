//
//  PaxCounterView.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 26/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class PaxCounterView: UIView {
    
    @IBOutlet weak var addButton:UIButton!
    @IBOutlet weak var subtractButton:UIButton!
    @IBOutlet weak var paxCountTextField:UITextField!
    @IBOutlet weak var saveButton:UIButton!
    @IBOutlet weak var cancelButton:UIButton!
    
    var overlayView:UIView?
    var dialogView:UIView?
    
    var maxPaxCount:Int?
    var minPaxCount:Int = 1
    var paxCount:Int?
    var currentStop:ScheduledRouteStop?
    var jobDetail:CurrentRideDetail?
    var tripId:String?
    var saveButtonCallback: (()->())?
    
    var tcpClient = CommandClient.shared
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: UIApplication.shared.keyWindow!.frame)
        loadView()
        setupView()
    }
    
    required init?(jobDetail:CurrentRideDetail, currentStop:ScheduledRouteStop, rideId:String) {
        super.init(frame: UIApplication.shared.keyWindow!.frame)
        
        self.jobDetail = jobDetail
        self.currentStop = currentStop
        self.maxPaxCount = Int(jobDetail.paxCount!)!
        self.paxCount = maxPaxCount
        self.tripId = rideId
        
        loadView()
        setupView()
    }
    
    
    func loadView() {
        dialogView = Bundle.main.loadNibNamed("PaxCounterView", owner: self, options: nil)![0] as? UIView
        self.frame = UIApplication.shared.keyWindow!.frame
        dialogView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - 50, height: (self.frame.size.width - 50)*(1/2.3))//CGRect(0, 0, self.frame.size.width, self.frame.size.height)
        dialogView?.center = self.center
        dialogView?.cornerRadius = 20
        self.addSubview(dialogView!)
    }
    
    func setupView()
    {
        self.addButton.makeCircle = true
        self.subtractButton.makeCircle = true
        paxCount = maxPaxCount
        self.paxCountTextField.text = String(describing: paxCount!)
        self.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        self.subtractButton.addTarget(self, action: #selector(subtractButtonTapped), for: .touchUpInside)
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
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
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
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
    
    func addButtonTapped()
    {
        guard let paxCount = self.paxCount else {return}
        guard let maxPaxCount = self.maxPaxCount else {return}
        guard paxCount < maxPaxCount else {return}
        
        self.paxCount! += 1
        paxCountTextField.text = String(self.paxCount!)
    }
    
    func subtractButtonTapped()
    {
        guard let paxCount = self.paxCount else {return}
        guard paxCount > minPaxCount else {return}
        
        self.paxCount! -= 1
        paxCountTextField.text = String(self.paxCount!)
    }
    
    func saveButtonTapped()
    {
        guard let deviceId = Defaults[.deviceId] else {return}
        guard let lat = Defaults[.lastLatitude] else {return}
        guard let lon = Defaults[.lastLongitude] else {return}
        guard let jobDetail = self.jobDetail else {return}
        guard let currentStop = self.currentStop else {return}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let deviceTime = dateFormatter.string(from: Date())
        
        
        tcpClient.loadPassenger(deviceId: deviceId, refId: jobDetail.refId!, rideId: self.tripId!, stopId: currentStop.stopId!, deviceTime: deviceTime, lat: String(lat), lon: String(lon), sourceTypeId: jobDetail.sourceTypeId!, paxCount: String(describing: self.paxCount!), paxDetailId: jobDetail.paxDetailId!) { (success) in
            
            if success
            {
                if self.saveButtonCallback != nil
                {
                    self.hide()
                    self.saveButtonCallback!()
                }
            }
            else
            {
                showError(title: "Alert", message: "Action Failed, Please try again.")
            }
        }
    }
    
    func cancelButtonTapped()
    {
        self.hide()
    }
}
