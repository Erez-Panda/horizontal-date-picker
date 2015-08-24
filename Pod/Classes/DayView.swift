//
//  dayView.swift
//  Panda4doctor
//
//  Created by Erez Haim on 6/17/15.
//  Copyright (c) 2015 Erez. All rights reserved.
//

import UIKit

class DayView: UIView {
    
    private let monthLabel = UILabel()
    private let dayLabel = UILabel()
    private let dayNameLabel = UILabel()
    private let tapRec = UITapGestureRecognizer()
    private let control = UIControl()
    private let badge = UILabel()
    
    var selectedBackgroundColor = UIColor.lightGrayColor()
    var selectedTextColor = UIColor.whiteColor()
    var badgeColor = UIColor(red:66/255, green:122/255, blue:219/255, alpha:1.0)

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
                    backgroundColor = UIColor(red:66/255, green:122/255, blue:219/255, alpha:0.2)
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
        addSubview(monthLabel)
        addSubview(dayLabel)
        addSubview(dayNameLabel)
        addSubview(badge)
        
        centerXView(monthLabel)
        topMarginView(monthLabel, margin: 20)
        
        centerXView(dayLabel)
        centerYView(dayLabel)
        
        centerXView(dayNameLabel)
        bottomMarginView(dayNameLabel, margin: -20)
        
        addGestureRecognizer(tapRec)
        tapRec.addTarget(self, action: "tap:")
        
        monthLabel.font = UIFont(name: "OpenSans", size: 16)
        dayLabel.font = UIFont(name: "OpenSans", size: 20)
        dayNameLabel.font = UIFont(name: "OpenSans", size: 16)
        
        monthLabel.textColor = UIColor.lightGrayColor()
        dayLabel.textColor = UIColor.grayColor()
        dayNameLabel.textColor = UIColor.grayColor()
        
        badge.backgroundColor = badgeColor
        badge.textColor = UIColor.whiteColor()
        badge.textAlignment = NSTextAlignment.Center
        badge.layer.borderWidth = 1.0
        badge.layer.cornerRadius = 10
        badge.clipsToBounds = true
        badge.layer.borderColor = UIColor.clearColor().CGColor
        trailingMarginView(badge, margin: -8)
        topMarginView(badge, margin: 16)
        addSizeConstaints(badge, width: 20, height: 20)
    }
    
    func tap(sender: AnyObject){
        onTap?(sender: self)
        selected = true
    }
    
    func centerXView(view: UIView){
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let centerConstrain = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        addConstraint(centerConstrain)
    }
    
    func centerYView(view: UIView){
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let centerConstrain = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        addConstraint(centerConstrain)
    }
    
    func topMarginView(view: UIView, margin: CGFloat){
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let topConstrain = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: margin)
        addConstraint(topConstrain)
    }
    
    func trailingMarginView(view: UIView, margin: CGFloat){
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let trailingConstrain = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: margin)
        addConstraint(trailingConstrain)
    }
    
    func bottomMarginView(view: UIView, margin: CGFloat){
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let bottomConstrain = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.BottomMargin, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: margin)
        addConstraint(bottomConstrain)
    }
    
    func addSizeConstaints (view: UIView, width: CGFloat?, height: CGFloat?) -> [NSLayoutConstraint]{
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        var widthConstraint:NSLayoutConstraint = NSLayoutConstraint()
        var hightConstraint:NSLayoutConstraint = NSLayoutConstraint()
        if let w = width {
            widthConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: w)
            view.addConstraint(widthConstraint)
        }
        if let h = height {
            hightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: h)
            view.addConstraint(hightConstraint)
        }
        return [widthConstraint, hightConstraint]
    }
    
}
