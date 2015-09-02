//
//  dayView.swift
//  Panda4doctor
//
//  Created by Erez Haim on 6/17/15.
//  Copyright (c) 2015 Erez. All rights reserved.
//

import UIKit

class DayView: UIView {
    
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var dayNameLabel: UILabel!
    @IBOutlet var badge: UILabel!
    
    private let tapRec = UITapGestureRecognizer()
    private let control = UIControl()
    
    var selectedBackgroundColor = UIColor.lightGrayColor()
    var selectedTextColor = UIColor.whiteColor()
    var todayBackgroundColor = UIColor.whiteColor()
    var badgeBackgroundColor = UIColor(red:66/255, green:122/255, blue:219/255, alpha:1.0){
        didSet{
            badge.backgroundColor = badgeBackgroundColor
        }
    }
    
    var onTap: ((sender: AnyObject?) -> ())?
    
    var date: NSDate = NSDate() {
        didSet {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE"
            dayNameLabel.text = formatter.stringFromDate(date)
            
            formatter.dateFormat = "LLL"
            monthLabel.text = formatter.stringFromDate(date)
            
            formatter.dateFormat = "dd"
            dayLabel.text = formatter.stringFromDate(date)
        }
    }
    
    var badgeValue: Int = 0 {
        didSet{
            if badgeValue > 0 {
                badge.hidden = false
                badge.text = "\(badgeValue)"
                
            } else {
                badge.hidden = true
            }
        }
    }
    
    var selected: Bool = false {
        didSet{
            if selected {
                backgroundColor = selectedBackgroundColor
                monthLabel.textColor = selectedTextColor
                dayLabel.textColor = selectedTextColor
                dayNameLabel.textColor = selectedTextColor
            } else {
                if date.isEqualToDate(NSCalendar.currentCalendar().startOfDayForDate(NSDate())) {
                    backgroundColor = todayBackgroundColor
                } else {
                    backgroundColor = UIColor.clearColor()
                }
                monthLabel.textColor = UIColor.lightGrayColor()
                dayLabel.textColor = UIColor.grayColor()
                dayNameLabel.textColor = UIColor.grayColor()
            }
        }
    }
    
    // MARK: Initializations
    
    required override internal init(frame: CGRect) {
        super.init(frame: frame)
        initDayView()
    }
    
    required internal init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initDayView()
    }
    
    func initDayView(){
        addGestureRecognizer(tapRec)
        tapRec.addTarget(self, action: "tap:")
    }
    
    override func awakeFromNib() {
        badge.backgroundColor = badgeBackgroundColor
        badge.layer.borderWidth = 1.0
        badge.layer.cornerRadius = 10
        badge.clipsToBounds = true
        badge.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func tap(sender: AnyObject){
        onTap?(sender: self)
        selected = true
    }
    
    
}
