//
//  Extensions.swift
//  DriverApp
//
//  Created by Srinivas Vemuri on 5/2/16.
//  Copyright © 2016 SuperShuttle. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import UIKit
import SwiftyUserDefaults

//extension Collection {
//    
//    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
//    subscript (safe index: Index) -> Generator.Element? {
//        let retIndices = try! indices.contains(where: index) ? self[index] : nil
//        return indices.//contains(where: index) ? self[index] : nil
//    }
//    
//}

extension UIWindow {
    
    func captureScreenshotJPEGBase64() -> String? {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let screenshot = image else {
            return nil
        }
        
        return screenshot.base64JPEGString()
    }
}

extension UIImage {
    
    func base64JPEGString() -> String? {
        
        guard let jpeg = UIImageJPEGRepresentation(self, 0.75) else {
            return nil
        }
        
        return jpeg.base64EncodedString(options: .lineLength64Characters)//base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
    
}

extension String {
    
    func base64Encoded() -> String? {
        
        let plainData = data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: [])//.base64EncodedStringWithOptions([])
        return base64String
    }
    
    func base64Decoded() -> String? {
        
        guard let decodedData = NSData(base64Encoded: self as String, options:.ignoreUnknownCharacters) else {
            return nil
        }
        
        let decodedString = String(data: decodedData as Data, encoding: String.Encoding.utf8)
        return decodedString
    }
}

extension String {
    
    func convertStringToDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
}

extension Int {
    
    func minutesToHoursMinutes() -> String {
        let minutes = self
        let hoursInt = minutes / 60
        let minutesInt = minutes % 60
        let hourString = String(hoursInt)
        let mintuesString = String(minutesInt)
        return hourString + "h " + mintuesString + "m"
    }
    
}

//extension UIImage {
//    
//    class func dottedLine(radius: CGFloat, space: CGFloat, numberOfPattern: CGFloat) -> UIImage {
//        
//        let path = UIBezierPath()
//        path.moveToPoint(CGPointMake(radius/2, radius/2))
//        path.addLineToPoint(CGPointMake((numberOfPattern)*(space+1)*radius, radius/2))
//        path.lineWidth = radius
//        
//        let dashes: [CGFloat] = [path.lineWidth * 0, path.lineWidth * (space+1)]
//        path.setLineDash(dashes, count: dashes.count, phase: 0)
//        path.lineCapStyle = CGLineCap.Round
//        
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake((numberOfPattern)*(space+1)*radius, radius), false, 1)
//        UIColor.blackColor().setStroke()
//        path.stroke()
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return image!
//        
//    }
//}
//
//extension UIView {
//    
//    @IBInspectable var bottomBorder: Bool {
//        get {
//            return self.layer.getSublayerNamed("bottom_border") != nil
//        }
//        set {
//            if newValue == true {
//                let bottomBorder = CALayer()
//                bottomBorder.backgroundColor = UIColor.blackColor().CGColor
//                bottomBorder.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 2.0, CGRectGetWidth(self.frame), 2.0)
//                bottomBorder.name = "bottom_border"
//                self.layer.addSublayer(bottomBorder)
//            }
//        }
//    }
//    
//    @IBInspectable var makeCircle: Bool {
//        get {
//            return self.layer.cornerRadius != 0.5 * self.bounds.size.width
//        }
//        set {
//            self.layer.cornerRadius = 0.5 * self.bounds.size.width
//            self.clipsToBounds = true
//        }
//    }
//    
//    @IBInspectable var materialShadow: Bool {
//        get {
//            return self.layer.shadowOffset == CGSizeMake(0, 3.0)
//        }
//        set {
//            self.layer.shadowOffset = CGSizeMake(0, 3.0)
//            self.layer.shadowRadius = 3.0
//            self.layer.shadowOpacity = 0.5
//            self.layer.masksToBounds = false
//        }
//    }
//    
//    @IBInspectable var shadowColor: Bool {
//        get {
//            return self.layer.shadowOffset == CGSizeMake(0, 3.0)
//        }
//        set {
//            self.layer.shadowOffset = CGSizeMake(0, 3.0)
//            self.layer.shadowRadius = 3.0
//            self.layer.shadowOpacity = 0.5
//            self.layer.masksToBounds = false
//        }
//    }
//    
//}
//
//
//extension CALayer {
//    
//    func getSublayerNamed(name: String) -> CALayer? {
//        
//        guard let sublayers = self.sublayers where sublayers.count > 0 else {
//            return nil
//        }
//        
//        for l in sublayers {
//            if l.name == name {
//                return l
//            }
//        }
//        
//        return nil
//    }
//    
//}
//
//extension String
//{
//    func trim() -> String
//    {
//        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//    }
//}
//
//extension UIView {
//    func animateConstraintWithDuration(duration: NSTimeInterval = 0.5) {
//        UIView.animateWithDuration(duration, animations: { [weak self] in
//            self?.layoutIfNeeded() ?? ()
//            })
//    }
//}
//
//extension UIView {
//    
//    var width:      CGFloat { return self.frame.size.width }
//    var height:     CGFloat { return self.frame.size.height }
//    var size:       CGSize  { return self.frame.size}
//    
//    var origin:     CGPoint { return self.frame.origin }
//    var x:          CGFloat { return self.frame.origin.x }
//    var y:          CGFloat { return self.frame.origin.y }
//    var centerX:    CGFloat { return self.center.x }
//    var centerY:    CGFloat { return self.center.y }
//    
//    var left:       CGFloat { return self.frame.origin.x }
//    var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
//    var top:        CGFloat { return self.frame.origin.y }
//    var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
//    
//    func setWidth(width:CGFloat)
//    {
//        self.frame.size.width = width
//    }
//    
//    func setHeight(height:CGFloat)
//    {
//        self.frame.size.height = height
//    }
//    
//    func setSize(size:CGSize)
//    {
//        self.frame.size = size
//    }
//    
//    func setOrigin(point:CGPoint)
//    {
//        self.frame.origin = point
//    }
//    
//    func setX(x:CGFloat) //only change the origin x
//    {
//        self.frame.origin = CGPointMake(x, self.frame.origin.y)
//    }
//    
//    func setY(y:CGFloat) //only change the origin x
//    {
//        self.frame.origin = CGPointMake(self.frame.origin.x, y)
//    }
//    
//    func setCenterX(x:CGFloat) //only change the origin x
//    {
//        self.center = CGPointMake(x, self.center.y)
//    }
//    
//    func setCenterY(y:CGFloat) //only change the origin x
//    {
//        self.center = CGPointMake(self.center.x, y)
//    }
//    
//    func roundCorner(radius:CGFloat)
//    {
//        self.layer.cornerRadius = radius
//    }
//    
//    func setTop(top:CGFloat)
//    {
//        self.frame.origin.y = top
//    }
//    
//    func setLeft(left:CGFloat)
//    {
//        self.frame.origin.x = left
//    }
//    
//    func setRight(right:CGFloat)
//    {
//        self.frame.origin.x = right - self.frame.size.width
//    }
//    
//    func setBottom(bottom:CGFloat)
//    {
//        self.frame.origin.y = bottom - self.frame.size.height
//    }
//}
//
//extension UIView {
//    
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return self.layer.cornerRadius
//        }
//        set {
//            self.layer.cornerRadius = newValue
//            self.clipsToBounds = true
//        }
//    }
//}
//
//extension UIImage{
//    
//    func alpha(value:CGFloat)->UIImage
//    {
//        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
//        
//        var ctx = UIGraphicsGetCurrentContext();
//        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
//        
//        CGContextScaleCTM(ctx!, 1, -1);
//        CGContextTranslateCTM(ctx!, 0, -area.size.height);
//        CGContextSetBlendMode(ctx!, CGBlendMode.Multiply); // if this causes an error, replace `kCGBlendModeMultiply` with `CGBlendMode.Multiply`
//        CGContextSetAlpha(ctx!, value);
//        CGContextDrawImage(ctx!, area, self.CGImage!);
//        
//        var newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        return newImage!;
//    }
//}
//
//extension UIButton {
//    
//    private func actionHandleBlock(action:(() -> Void)? = nil) {
//        struct __ {
//            static var action :(() -> Void)?
//        }
//        if action != nil {
//            __.action = action
//        } else {
//            __.action?()
//        }
//    }
//    
//    @objc private func triggerActionHandleBlock() {
//        self.actionHandleBlock()
//    }
//    
//    func actionHandle(controlEvents control :UIControlEvents, ForAction action:() -> Void) {
//        self.actionHandleBlock(action)
//        self.addTarget(self, action: #selector(UIButton.triggerActionHandleBlock), forControlEvents: control)
//    }
//}
//
//extension String {
//    
//    func attributedStringWithHTML() -> NSAttributedString {
//        let string = "<style>b{font-family: 'Roboto-Medium'; font-size:18;} body{font-family: 'Roboto'; font-size:18;}</style>" + self
//        let attrStr = try! NSAttributedString(
//            data: string.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
//            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
//            documentAttributes: nil)
//        return attrStr
//    }
//    
//    func boldString(fontSize: Int = 18, color: String = "white") -> NSAttributedString {
//        let string = "<style>body{font-family: 'Roboto-Medium'; font-size:\(fontSize); color:\(color);}</style>" + self
//        let attrStr = try! NSAttributedString(
//            data: string.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
//            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
//            documentAttributes: nil)
//        return attrStr
//    }
//    
//}
//extension NSDate {
//    
//    func isToday() -> Bool {
//        
//        let calendar = NSCalendar.currentCalendar()
//        let now = NSDate()
//        let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: now, toDate: self, options: NSCalendarOptions())
//        
//        return (components.day > 0 || components.hour < 0) ? false : true
//    }
//    
//    func isTomorrow() -> Bool {
//        return NSCalendar.currentCalendar().isDateInTomorrow(self)
//    }
//    
//    func friendlyDay() -> String {
//   
//        if NSCalendar.currentCalendar().isDateInToday(self) {
//            return NSLocalizedString("Today", comment: "")
//        }
//        
//        if NSCalendar.currentCalendar().isDateInTomorrow(self) {
//            return NSLocalizedString("Tomorrow", comment: "")
//        }
//        
//        return ""
//    }
//    
//    func dayOfTheWeek() -> String? {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        return dateFormatter.stringFromDate(self) ?? ""
//    }
//    
//}
//
//extension NSDate
//{
//    
//    convenience init(dateString1:String) {
//        // Supports this format: 09/02/16 10:52:23
//        // Take a formatted date time string and returns a NSDate
//        let dateStringFormatter = NSDateFormatter()
//        dateStringFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
//        let d = dateStringFormatter.dateFromString(dateString1)!
//        self.init(timeInterval:0, sinceDate:d)
//    }
//    
//    convenience init(dateString2:String) {
//        // Supports this format: 2016-08-30T11:45:00
//        // Take a formatted date time string and returns a NSDate
//        let betterDateString = dateString2.componentsSeparatedByString(".")[0]
//        let dateStringFormatter = NSDateFormatter()
//        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        let d = dateStringFormatter.dateFromString(betterDateString)!
//        self.init(timeInterval:0, sinceDate:d)
//    }
//    
//    convenience init(dateString3:String) {
//        // Supports this format: 2016-09-02 00:55:00 +0000
//        // Take a formatted date time string and returns a NSDate
//        let dateStringFormatter = NSDateFormatter()
//        dateStringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZ"
//        let d = dateStringFormatter.dateFromString(dateString3)!
//        self.init(timeInterval:0, sinceDate:d)
//    }
//    
//    convenience init(justMilitaryTime:String) {
//        // Supports this format: 1157
//        // Take a formatted time string and returns a NSDate
//        let dateStringFormatter = NSDateFormatter()
//        dateStringFormatter.dateFormat = "HHmm"
//        let d = dateStringFormatter.dateFromString(justMilitaryTime)!
//        self.init(timeInterval:0, sinceDate:d)
//    }
//    
//}
//
//extension UIApplication {
//    
//    class func topViewController() -> UIViewController? {
//        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let mainNC = delegate.mainNC
//        return mainNC?.childViewControllers.last
//    }
//    
//}
//
//extension AppDelegate {
//    
//    func currentNC() -> SSNavigationController {
//        return (UIApplication.sharedApplication().delegate as! AppDelegate).mainNC!
//    }
//    
//}
//
//extension Character {
//    func isEmoji() -> Bool {
//        return Character(UnicodeScalar(0x1d000)) <= self && self <= Character(UnicodeScalar(0x1f77f))
//            || Character(UnicodeScalar(0x2100)) <= self && self <= Character(UnicodeScalar(0x26ff))
//    }
//}
//
//extension String {
//    func stringByRemovingEmoji() -> String {
//        return String(self.characters.filter{!$0.isEmoji()})
//    }
//}
//
//extension String {
//    subscript (r: Range<Int>) -> String {
//        get {
//            let startIndex = self.startIndex.advancedBy(r.startIndex)
//            let endIndex = startIndex.advancedBy(r.endIndex - r.startIndex)
//            
//            return self[Range(start: startIndex, end: endIndex)]
//        }
//    }
//}
//
//extension String
//{
//    var parseJSONString: AnyObject?
//    {
//        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
//        
//        if let jsonData = data
//        {
//            // Will return an object or nil if JSON decoding fails
//            do
//            {
//                let message = try NSJSONSerialization.JSONObjectWithData(jsonData, options:.MutableContainers)
//                if let jsonResult = message as? NSDictionary
//                {
//                    print(jsonResult)
//                    
//                    return jsonResult //Will return the json array output
//                }
//                else
//                {
//                    return nil
//                }
//            }
//            catch let error as NSError
//            {
//                print("An error occurred: \(error)")
//                return nil
//            }
//        }
//        else
//        {
//            // Lossless conversion of the string was not possible
//            return nil
//        }
//    }
//}
//
//extension Array where Element : Equatable {
//    var unique: [Element] {
//        var uniqueValues: [Element] = []
//        forEach { item in
//            if !uniqueValues.contains(item) {
//                uniqueValues += [item]
//            }
//        }
//        return uniqueValues
//    }
//}
//
//extension String {
//    
//    public func friendlyEventTime() -> String {
//        // 09/02/16 10:52:23 -> 11:45
//    
//        let date = NSDate(dateString1: self)
//        let dateFromat = NSDateFormatter()
//        dateFromat.dateFormat = "HH:mm"
//        return dateFromat.stringFromDate(date)
//    }
//    
//    public func friendlyEventTime1() -> String {
//        // 09/02/16 10:52:23 -> 11:45
//        
//        let betterDate = self.componentsSeparatedByString(".")[0]
//        
//        let date = NSDate(dateString2: betterDate)
//        let dateFromat = NSDateFormatter()
//        dateFromat.dateFormat = "HH:mm"
//        return dateFromat.stringFromDate(date)
//    }
//    
//    public func friendlyWaypointMilitaryTime() -> String {
//        // 09/02/16 10:52:23 -> 10:45
//        
//        let betterDate = self.componentsSeparatedByString(".")[0]
//        
//        let date = NSDate(dateString2: betterDate)
//        let dateFromat = NSDateFormatter()
//        dateFromat.dateFormat = "HH:mm"
//        return dateFromat.stringFromDate(date)
//    }
//    
//    public func friendlyEventTime2() -> String {
//        // 2016-08-30T11:45:00 -> Friday 13:44
//
//        // Strip any random milisonds... for example: "2016-09-14T00:22:40.833"
//        let betterDate = self.componentsSeparatedByString(".")[0]
//        
//        let date = NSDate(dateString2: betterDate)
//        let timeFormat = NSDateFormatter()
//        timeFormat.dateFormat = "EEEE HH:mm"
//
//        return timeFormat.stringFromDate(date)
//        
//    }
//    
//    public func friendlyEventTime3() -> String {
//        // 2016-08-30T11:45:00 -> 13:32 (if today)
//        // 2016-08-30T11:45:00 -> Sept 10
//        
//        let date = NSDate(dateString1: self)
//        let dateFromat = NSDateFormatter()
//        
//        if date.isToday() {
//            dateFromat.dateFormat = "H:mm"
//        }
//        else {
//            dateFromat.dateFormat = "MMM d"
//        }
//        
//        return dateFromat.stringFromDate(date)
//        
//    }
//    
//    public func friendlyEventTime4() -> String {
//        // 2016-08-30T12:45:00 -> 14:20
//        
//        // Strip any random milisonds... for example: "2016-09-14T00:22:40.833"
//        let betterDate = self.componentsSeparatedByString(".")[0]
//        
//        let date = NSDate(dateString2: betterDate)
//        let timeFromat = NSDateFormatter()
//        timeFromat.dateFormat = "HH:mm"
//        
//        return timeFromat.stringFromDate(date)
//    }
//    
//    
//    public func friendlyEventDayOrTime() -> String {
//        // 09/02/16 10:52:23 -> Tuesday
//        // 09/02/16 10:52:23 -> 10:54 (if today)
//        
//        let date = NSDate(dateString1: self)
//        
//        if date.isToday() {
//            let dateFromat = NSDateFormatter()
//            dateFromat.dateFormat = "H:mm"
//            return dateFromat.stringFromDate(date)
//        }
//        else {
//            let dateFromat = NSDateFormatter()
//            dateFromat.dateFormat = "EEEE"
//            return dateFromat.stringFromDate(date)
//        }
//
//    }
//    
//    public func friendlyEventDay() -> String {
//        // 09/02/16 10:52:23 -> Tuesday
//        
//        let date = NSDate(dateString2: self)
//        let dateFromat = NSDateFormatter()
//        dateFromat.dateFormat = "EEEE"
//        return dateFromat.stringFromDate(date)
//    }
//    
//    public func friendlyEventDay2() -> String {
//        // 09/02/16 10:52:23 -> Tuesday
//        
//        let date = NSDate(dateString1: self)
//        let dateFromat = NSDateFormatter()
//        dateFromat.dateFormat = "EEEE"
//        return dateFromat.stringFromDate(date)
//    }
//    
//    public func friendlyEventDay3() -> String {
//        
//        let date = NSDate(dateString2: self)
//        let dateFromat = NSDateFormatter()
//        
//        if date.isToday() {
//            dateFromat.dateFormat = "HH:mm"
//        }
//        else {
//            dateFromat.dateFormat = "MMM d"
//        }
//        
//        return dateFromat.stringFromDate(date)
//        
//    }
//    
//    public func friendlyEventDateTime() -> String {
//        // 2016-08-30T11:45:00 -> Friday 13:07
//
//        var dateString = ""
//        let date = NSDate(dateString2: self)
//
//        let dateFromat = NSDateFormatter()
//        dateFromat.dateFormat = "EEEE HH:mm"
//        dateString = dateFromat.stringFromDate(date)
//        
//        return dateString
//    }
//    
//    public func friendlyEventTimeUTC() -> String {
//        // 2016-09-02 00:55:00 +0000 -> Today
//        
//        let date = NSDate(dateString3: self)
//        let dateFromat = NSDateFormatter()
//        dateFromat.dateFormat = "HH:mm"
//        return dateFromat.stringFromDate(date)
//    }
//    
//}
//
//
//extension CLLocationCoordinate2D {
//    public func randomCoordinateNearby() -> CLLocationCoordinate2D {
//        let randLat = self.latitude + Double(Int.random(-1, max: 1))*Double.random(0.08, max: 0.2)
//        let randLong = self.longitude + Double(Int.random(-1, max: 1))*Double.random(0.08, max: 0.2)
//        return CLLocationCoordinate2D(latitude: randLat, longitude: randLong)
//    }
//}
//
//public extension Int {
//
//    public static var random:Int {
//        get {
//            return Int.random(Int.max)
//        }
//    }
//
//    public static func random(n: Int) -> Int {
//        return Int(arc4random_uniform(UInt32(n)))
//    }
//
//    public static func random(min: Int, max: Int) -> Int {
//        return Int.random(max - min + 1) + min
//    }
//}
//public extension Double {
//
//    public static var random:Double {
//        get {
//            return Double(arc4random()) / 0xFFFFFFFF
//        }
//    }
//
//    public static func random(min: Double, max: Double) -> Double {
//        return Double.random * (max - min) + min
//    }
//    
//    func roundToPlaces(places:Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return round(self * divisor) / divisor
//    }
//}
//public extension Float {
//
//    public static var random:Float {
//        get {
//            return Float(arc4random()) / 0xFFFFFFFF
//        }
//    }
//
//    public static func random(min min: Float, max: Float) -> Float {
//        return Float.random * (max - min) + min
//    }
//}
//
//public extension CGFloat {
//
//    public static var randomSign:CGFloat {
//        get {
//            return (arc4random_uniform(6) == 0) ? 1.0 : -1.0
//        }
//    }
//
//    public static var random:CGFloat {
//        get {
//            return CGFloat(Float.random)
//        }
//    }
//
//    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
//        return CGFloat.random * (max - min) + min
//    }
//}
//
//
//public extension UIView {
//    public class func fromNib(nibNameOrNil: String? = nil) -> Self {
//        return fromNib(nibNameOrNil, type: self)
//    }
//    
//    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
//        let v: T? = fromNib(nibNameOrNil, type: T.self)
//        return v!
//    }
//    
//    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
//        var view: T?
//        let name: String
//        if let nibName = nibNameOrNil {
//            name = nibName
//        } else {
//            // Most nibs are demangled by practice, if not, just declare string explicitly
//            name = nibName
//        }
//        let nibViews = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
//        for v in nibViews! {
//            if let tog = v as? T {
//                view = tog
//            }
//        }
//        return view
//    }
//    
//    public class var nibName: String {
//        let name = "\(self)".componentsSeparatedByString(".").first ?? ""
//        return name
//    }
//    public class var nib: UINib? {
//        if let _ = NSBundle.mainBundle().pathForResource(nibName, ofType: "nib") {
//            return UINib(nibName: nibName, bundle: nil)
//        } else {
//            return nil
//        }
//    }
//}
//
//extension String {
//    
//    static func random(length: Int = 20) -> String {
//        
//        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        var randomString: String = ""
//        
//        for _ in 0..<length {
//            let randomValue = arc4random_uniform(UInt32(base.characters.count))
//            randomString += "\(base[base.startIndex.advancedBy(Int(randomValue))])"
//        }
//        
//        return randomString
//    }
//}
//
//extension String
//{
//    func replace(target: String, withString: String) -> String
//    {
//        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
//    }
//}
//
//extension String {
//    func trunc(length: Int, trailing: String? = "") -> String {
//        if self.characters.count > length {
//            return self.substringToIndex(self.startIndex.advancedBy(length)) + (trailing ?? "")
//        } else {
//            return self
//        }
//    }
//}
//
//extension String {
//    
//    subscript (i: Int) -> Character {
//        return self[self.startIndex.advancedBy(i)]
//    }
//    
//    subscript (i: Int) -> String {
//        return String(self[i] as Character)
//    }
//    
//}
//
//func += <K,V> (inout left: Dictionary<K,V>, right: Dictionary<K,V>?) {
//    guard let right = right else { return }
//    right.forEach { key, value in
//        left.updateValue(value, forKey: key)
//    }
//}
extension UIApplication {
    
    class func topViewController() -> UIViewController? {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let mainNC = delegate.mainNC
        return mainNC?.childViewControllers.last
    }
    
}

extension DefaultsKeys {
    static let deviceId = DefaultsKey<String?>("deviceId")
    static let appVersion = DefaultsKey<String?>("appVersion")
    static let uniqueId = DefaultsKey<String?>("uniqueId") // only used for registering a new device
    static let isLoggedIn = DefaultsKey<Bool?>("isLoggedIn")
    static let isDeviceRegistered = DefaultsKey<Bool?>("isDeviceRegistered")
}

