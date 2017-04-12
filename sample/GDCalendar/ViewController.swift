//
//  ViewController.swift
//  GDCalendar
//
//  Created by Saeid Basirnia on 4/9/17.
//  Copyright © 2017 Saeid Basirnia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GDCalendarDateDelegate {
    
    @IBOutlet weak var calendar: GDCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        self.dateLabel.text = parseDate(date: calendar.currentDate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func parseDate(date: Date) -> String{
        let dc = date.componentsOfDate()
        return "\(dc.year) / \(dc.month) / \(dc.day)".stringToPersian()
    }
    
    func onDateTap(date: Date) {
        self.dateLabel.text = parseDate(date: date)
        print(date)
    }
    
    @IBAction func gotoNext(_ sender: Any) {
        // swipe right gesture is activated by default to show next month
        calendar.gotoNextMonth()
    }
    
    @IBAction func gotoPrevious(_ sender: Any) {
        // swipe left gesture is activated by default to show previous month
        calendar.gotoPreviousMonth()
    }
}

