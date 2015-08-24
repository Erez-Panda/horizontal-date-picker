//
//  DateSelectorView.swift
//  Panda4doctor
//
//  Created by Erez Haim on 6/16/15.
//  Copyright (c) 2015 Erez. All rights reserved.
//

import UIKit

@objc public protocol DateSelectorViewDelegate {
    /**
    Returns the selected date when touch events end
    */
    func dateSelectorView(dateSelectorView: DateSelectorView, didSelecetDate date: NSDate)
}

@IBDesignable
public class DateSelectorView: UIView, UIScrollViewDelegate {
    
    private let SEC_IN_DAY: Int = 60*60*24
    
    public var delegate: DateSelectorViewDelegate?
    
    @IBInspectable public var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            if (oldValue != borderColor){
                for dayView in daysBuffer {
                    dayView.layer.borderColor = borderColor.CGColor
                }
            }
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 1 {
        didSet {
            if (oldValue != borderWidth){
                for dayView in daysBuffer {
                    dayView.layer.borderWidth = borderWidth
                }
            }
        }
    }
    
    @IBInspectable public var dayWidth: CGFloat = 100 {
        didSet {
            if (oldValue != dayWidth){
                for dayView in daysBuffer {
                    dayView.frame.size.width = dayWidth
                }
            }
        }
    }
    
    @IBInspectable public var startDate: NSDate = NSDate() {
        didSet {
            if (oldValue != startDate){
                self.refresh()
            }
        }
    }
    
    @IBInspectable public var daysBufferLength: Int = 30 {
        didSet {
            if (oldValue != daysBufferLength){
                self.refresh()
            }
        }
    }
    
    @IBInspectable public var minDate: NSDate? = nil {
        didSet {
            if let newMin = minDate{
                if newMin.laterDate(startDate) == newMin {
                    self.startDate = newMin
                }
            }
        }
    }
    
    @IBInspectable public var maxDate: NSDate? = nil {
        didSet {
            if let newMax = maxDate {
                let startToMaxDays = Int(newMax.timeIntervalSinceDate(startDate)/Double(SEC_IN_DAY))
                if startToMaxDays < 0{
                    self.startDate = newMax
                } else if startToMaxDays < self.daysBufferLength {
                    self.daysBufferLength = startToMaxDays
                }
            }
        }
    }
    
    @IBInspectable public var selectedDayBackgroundColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            if oldValue != selectedDayBackgroundColor{
                for dayView in daysBuffer {
                    dayView.selectedBackgroundColor = selectedDayBackgroundColor
                }
                selectedDay?.selected = true
            }
        }
    }
    
    @IBInspectable public var selectedDayTextColor: UIColor = UIColor.whiteColor() {
        didSet {
            if oldValue != selectedDayTextColor{
                for dayView in daysBuffer {
                    dayView.selectedTextColor = selectedDayTextColor
                }
                selectedDay?.selected = true
            }
        }
    }
    
    private var selectedDay : DayView?
    
    private var daysBuffer : Array<DayView> = []
    private var scrollView : UIScrollView!
    
    
    
    // MARK: Initializations
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initDayViews()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initDayViews()
    }
    
    
    func initDayViews(){
        scrollView = UIScrollView()
        scrollView.delegate = self
        self.addSubview(scrollView)
        constrainToParent(scrollView)
        for i in 0..<daysBufferLength {
            let dayView = createDayView(startDate.dateByAddingTimeInterval(Double(i*SEC_IN_DAY)))
            scrollView.addSubview(dayView)
            daysBuffer.append(dayView)
            if i == 0 {
                dayView.selected = true
                selectedDay = dayView
            }
            dayView.frame.origin.x = CGFloat(i) * (dayWidth - 1)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        //scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        scrollView.contentSize = CGSizeMake(CGFloat(daysBufferLength) * (dayWidth - 1), scrollView.frame.size.height)
        for dayView in daysBuffer{
            dayView.frame.size.height = scrollView.frame.size.height
        }
    }
    
    public func setBadgeForDate(date: NSDate, value: Int){
        for day in daysBuffer{
            if day.date.isEqualToDate(date) {
                day.badgeValue = value
            }
        }
    }
    
    func refresh(){
        scrollView.removeFromSuperview()
        daysBuffer.removeAll()
        initDayViews()
    }
    
    func createDayView(date: NSDate) -> DayView{
        let dayView = DayView(frame: CGRectMake(0, 0, dayWidth, scrollView.frame.height))
        dayView.layer.borderColor = self.borderColor.CGColor
        dayView.layer.borderWidth = self.borderWidth
        dayView.selectedBackgroundColor = self.selectedDayBackgroundColor
        dayView.selectedTextColor = self.selectedDayTextColor
        dayView.date = date
        dayView.onTap = dayWasTap
        
        return dayView
    }
    
    func dayWasTap(sender: AnyObject?) -> (){
        if let dayView = sender as? DayView{
            selectedDay = dayView
            delegate?.dateSelectorView(self, didSelecetDate: dayView.date)
        }
        for dayView in daysBuffer{
            dayView.selected = false
        }
    }
    
    func constrainToParent(view: UIView){
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        topMarginView(view, toItem: self, margin: 0)
        bottomMarginView(view, toItem: self, margin: 0)
        let leadingConstrain = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.LeadingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 8)
        addConstraint(leadingConstrain)
        let trainlingConstrain = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.TrailingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -8)
        addConstraint(trainlingConstrain)
    }
    
    func topMarginView(view: UIView, toItem: UIView, margin: CGFloat){
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let topConstrain = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: margin)
        toItem.addConstraint(topConstrain)
    }
    func bottomMarginView(view: UIView, toItem: UIView, margin: CGFloat){
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let bottomConstrain = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.BottomMargin, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: margin)
        toItem.addConstraint(bottomConstrain)
    }
    
    // MARK: scroll view delegate
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x + scrollView.frame.width > scrollView.contentSize.width - 2 * dayWidth{
            var daysToShow = daysBufferLength/2
            if let mDate = maxDate {
                daysToShow = min(daysToShow, Int(mDate.timeIntervalSinceDate(daysBuffer.last!.date)/Double(SEC_IN_DAY)))
            }
            for i in daysBufferLength..<daysToShow + daysBufferLength{
                let dayView = createDayView(daysBuffer[0].date.dateByAddingTimeInterval(Double(i*SEC_IN_DAY)))
                scrollView.addSubview(dayView)
                daysBuffer.append(dayView)
                if dayView.date == selectedDay?.date {
                    dayView.selected = true
                }
                dayView.frame.origin.x = CGFloat(i) * (dayWidth - 1)
            }
            //Remove out of buffer elements from start
            while daysBuffer.count > daysBufferLength {
                daysBuffer.removeAtIndex(0).removeFromSuperview()
            }
            for dayView in daysBuffer{
                dayView.frame.origin.x -= (CGFloat(daysToShow) * (dayWidth - 1))
            }
            scrollView.contentOffset.x = scrollView.contentOffset.x - CGFloat(daysToShow) * (dayWidth - 1)
        }
        if scrollView.contentOffset.x < 2 * dayWidth{
            var daysToShow = daysBufferLength/2
            if let mDate = minDate {
                daysToShow = min(daysToShow, Int(daysBuffer[0].date.timeIntervalSinceDate(mDate)/Double(SEC_IN_DAY)))
            }
            let currStartDate = daysBuffer[0].date.dateByAddingTimeInterval(Double(-SEC_IN_DAY))
            for i in 0..<daysToShow{
                let dayView = createDayView(currStartDate.dateByAddingTimeInterval(Double(-i*SEC_IN_DAY)))
                scrollView.addSubview(dayView)
                daysBuffer.insert(dayView, atIndex: 0)
                if dayView.date == selectedDay?.date {
                    dayView.selected = true
                }
                dayView.frame.origin.x = CGFloat(-(i+1)) * (dayWidth - 1)
            }
            //Remove out of buffer elements
            while daysBuffer.count > daysBufferLength {
                daysBuffer.removeLast().removeFromSuperview()
            }
            for dayView in daysBuffer{
                dayView.frame.origin.x += (CGFloat(daysToShow) * (dayWidth - 1))
            }
            scrollView.contentOffset.x = scrollView.contentOffset.x + CGFloat(daysToShow) * (dayWidth - 1)
        }
    }

}
