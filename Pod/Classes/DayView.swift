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
    
    var selectedBackgroundColor = UIColor.lightGrayColor()
    var selectedTextColor = UIColor.whiteColor()

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
    
    var selected: Bool = false {
        didSet{
            if selected {
                backgroundColor = selectedBackgroundColor
                monthLabel.textColor = selectedTextColor
                dayLabel.textColor = selectedTextColor
                dayNameLabel.textColor = selectedTextColor
            } else {
                backgroundColor = UIColor.clearColor()
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
    func bottomMarginView(view: UIView, margin: CGFloat){
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let bottomConstrain = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.BottomMargin, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: margin)
        addConstraint(bottomConstrain)
    }
    
}
