//
//  ViewController.swift
//  GDCalendar
//
//  Created by Saeid Basirnia on 4/9/17.
//  Copyright © 2017 Saeid Basirnia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var calendar: GDCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // `calendar.currentDate` returns today's date
        dateLabel.text = parseDate(date: calendar.currentDate)
        setProperties()
    }
    
    func parseDate(date: Date) -> String{
        /* `componentsOfDate` attribute of Date() will return date components (year, month, day).
         Also, month name and day full name are available using:
         - date.monthName (December)
         - date.dayName (Sunday)
         */
        let dc = date.componentsOfDate
        return "\(dc.year) / \(dc.month) / \(dc.day)".convertNumbers
    }
    
    func setProperties(){
        // Set `current_locale` for setting Calendar to specific locale.
        // If nothing is set, default phone locale will be selected
        UserDefaults.standard.set("fa_IR", forKey: "current_locale")
        
        // Selection date action when tapping a date
        calendar.dateSelectHandler = { [unowned self] date in
            let currentDate = "\(self.parseDate(date: date)) - \(date.monthName) - \(date.dayName)"
            self.dateLabel.text = currentDate
        }
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
