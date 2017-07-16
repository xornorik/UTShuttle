//
//  NodeCollectionViewCell.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 16/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

class UTSNodeCollectionViewCell: UICollectionViewCell {
    
    enum NodeType {
        case start
        case middle
        case middlePassed
        case middleReached
        case end
    }
    
    @IBOutlet weak var node:UIView!
    @IBOutlet weak var leftConnector:UIView!
    @IBOutlet weak var rightConnector:UIView!
    @IBOutlet weak var leftArrow:UILabel!
    @IBOutlet weak var rightArrow:UILabel!
    @IBOutlet weak var nodeLabel:UILabel!

    var type = NodeType.middle
    var name : String = "" {
        
        didSet{nodeLabel.text = name}
    }
    
    var shapeLayer:CAShapeLayer!
    var gradientLayer:CAGradientLayer!
    
    func setupCell()
    {
        node.makeCircle = true
        
        switch type {
        case .start:
            leftConnector.isHidden = true
            rightArrow.isHidden = true
            node.backgroundColor = ColorPalette.UTSTealLight
        case .middle:
            leftArrow.isHidden = true
            rightArrow.isHidden = true
        case .middlePassed:
            leftArrow.isHidden = true
            rightArrow.isHidden = true
            leftConnector.backgroundColor = ColorPalette.UTSTealLight
            rightConnector.backgroundColor = ColorPalette.UTSTealLight
            node.backgroundColor = ColorPalette.UTSTealLight
        case .middleReached:
            leftArrow.isHidden = true
            rightArrow.isHidden = true
            leftConnector.backgroundColor = ColorPalette.UTSTealLight
            rightConnector.backgroundColor = UIColor.lightGray
            node.backgroundColor = ColorPalette.UTSTealLight
        case .end:
            rightConnector.isHidden = true
            leftArrow.isHidden = true
            node.backgroundColor = UIColor.lightGray
        }
    }
    
    func drawLeftConnector(duration:TimeInterval, callback:@escaping ()->())
    {
        let startX:Int = Int(self.contentView.origin.x)
        let startY:Int = Int(self.contentView.center.y)
        let endX:Int = Int(self.contentView.bounds.size.width/2)
        let endY:Int = startY
        
        drawLineFromPointToPoint(startX: startX, toEndingX: endX, startingY: startY, toEndingY: endY, ofColor: ColorPalette.UTSTealLight, widthOfLine: 2, inView: self.contentView, duration: duration) {
            callback()
        }
    }
    
    func animateNodeColorChange(duration:TimeInterval, callback:@escaping ()->())
    {
        let startLocations = [0, 0]
        let endLocations = [1, 1]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ColorPalette.UTSTealLight.cgColor, UIColor.lightGray.cgColor]
        gradientLayer.frame = contentView.bounds
        gradientLayer.locations = startLocations as [NSNumber]?
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        node.layer.addSublayer(gradientLayer)
        
        CATransaction.begin()
        let anim = CABasicAnimation(keyPath: "locations")
        anim.fromValue = startLocations
        anim.toValue = endLocations
        anim.duration = duration
        CATransaction.setCompletionBlock {
            callback()
        }
        gradientLayer.add(anim, forKey: "loc")
        gradientLayer.locations = endLocations as [NSNumber]?
        CATransaction.commit()
        self.gradientLayer = gradientLayer
    }
    
    func drawRightConnector(duration:TimeInterval, callback:@escaping ()->())
    {
        let startX:Int = Int(self.contentView.center.x)
        let startY:Int = Int(self.contentView.center.y)
        let endX:Int = Int(self.contentView.bounds.size.width)
        let endY:Int = startY
        
        drawLineFromPointToPoint(startX: startX, toEndingX: endX, startingY: startY, toEndingY: endY, ofColor: ColorPalette.UTSTealLight, widthOfLine: 2, inView: self.contentView, duration: duration) {
            callback()
        }
    }
    
    func drawLineFromPointToPoint(startX: Int, toEndingX endX: Int, startingY startY: Int, toEndingY endY: Int, ofColor lineColor: UIColor, widthOfLine lineWidth: CGFloat, inView view: UIView, duration:TimeInterval, callback:@escaping ()->()) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        
        view.layer.addSublayer(shapeLayer)
        
        //animate it 
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = duration
        CATransaction.setCompletionBlock {
            callback()
        }
        shapeLayer.add(animation, forKey: "MyAnimation")
        CATransaction.commit()
        
        self.shapeLayer = shapeLayer
    }
    
    override func prepareForReuse() {
        leftArrow.isHidden = false
        rightArrow.isHidden = false
        leftConnector.isHidden = false
        rightConnector.isHidden = false
        leftConnector.backgroundColor = UIColor.lightGray
        rightConnector.backgroundColor = UIColor.lightGray
        node.backgroundColor = UIColor.lightGray
        
        if shapeLayer != nil
        {
            shapeLayer.removeFromSuperlayer()
            shapeLayer = nil
        }
        if gradientLayer != nil
        {
            gradientLayer.removeFromSuperlayer()
            gradientLayer = nil
        }
    }
}
