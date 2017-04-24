# GDCalendar

Persian date calendar component.
Customizable / Swipe gesture enabled

<img width="375" alt="screen shot 2017-04-13 at 01 42 00" src="https://cloud.githubusercontent.com/assets/9967486/24979816/e6595388-1fea-11e7-8b76-b2be3040e8e5.png">



# Requirements
xcode 8+

swift 3+

iOS 8+


# Installation
Install manually
------
Drag "GDCalendar.swift" to your project and use!

Install using Cocoapods
------
Soon!


# How to use
```
    //create an instance of GDCalendar() or assign to a view in storyboard
    //add 'GDCalendarDateDelegate' to ViewController

    let datePicker = GDCalendar()

    //delegate func
    func onDateTap(date: Date) {
        self.dateLabel.text = parseDate(date: date)
        print(date)
    }

    //customize the view. 
    datePicker.headerBackgroundColor = UIColor(red: 127 / 255, green: 124 / 255, blue: 118 / 255, alpha: 1.0)
    datePicker.headerItemColor = UIColor.white
    datePicker.itemsColor = UIColor.black
    
    datePicker.itemHighlightColor = UIColor(red: 162 / 255, green: 0 / 255, blue: 10 / 255, alpha: 1.0)
    datePicker.itemHighlightTextColor = UIColor.white
    
    datePicker.topViewBackgroundColor = UIColor.clear
    datePicker.topViewItemColor = UIColor.black
    
    datePicker.itemsFont = UIFont.systemFont(ofSize: 15)
    datePicker.headersFont = UIFont.boldSystemFont(ofSize: 13)


    //navigate with code
    datePicker.gotoNextMonth()    
    datePicker.gotoPreviousMonth()
```