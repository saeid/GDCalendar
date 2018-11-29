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
        UserDefaults.standard.set("fa_IR", forKey: "current_locale")
        //        UserDefaults.standard.set("en_US", forKey: "current_locale")
        
        calendar.dateSelectHandler = { [unowned self] date in
            let currentDate = "\(self.parseDate(date: date)) - \(date.monthName) - \(date.dayName)"
            self.dateLabel.text = currentDate
        }
        self.dateLabel.text = parseDate(date: calendar.currentDate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func parseDate(date: Date) -> String{
        let dc = date.componentsOfDate
        return "\(dc.year) / \(dc.month) / \(dc.day)".convertNumbers
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
