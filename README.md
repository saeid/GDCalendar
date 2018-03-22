# GDCalendar

## Now with *Locale* support
Calendar component with RTL and LTR language support.
Customizable / Swipe gesture enabled

**for changing Calendar view `calendar` you need to set any locale identifier like `UserDefaults.standard.set("en_US", forKey: "current_locale")`**

### ***For persian calendar set `current_locale` to `fa_IR`***


<img width="375" alt="screen shot 2017-04-13 at 01 42 00" src="https://cloud.githubusercontent.com/assets/9967486/24979816/e6595388-1fea-11e7-8b76-b2be3040e8e5.png">


## Requirements
- Xcode 8+
- Swift 3+
- iOS 8+


## Installation
Install Manually
------
Drag 'source' folder to your project and use!


## How to use

```swift
    // Create an instance of GDCalendar() or assign to a view in storyboard

    let datePicker = GDCalendar()

    datePicker.dateSelectHandler = { [weak self] date in
        // action when a date is selected
    }

    // Customize the view. 
    datePicker.headerBackgroundColor = UIColor(red: 127 / 255, green: 124 / 255, blue: 118 / 255, alpha: 1.0)
    datePicker.headerItemColor = UIColor.white
    datePicker.itemsColor = UIColor.black
    
    datePicker.itemHighlightColor = UIColor(red: 162 / 255, green: 0 / 255, blue: 10 / 255, alpha: 1.0)
    datePicker.itemHighlightTextColor = UIColor.white
    
    datePicker.topViewBackgroundColor = UIColor.clear
    datePicker.topViewItemColor = UIColor.black
    
    datePicker.itemsFont = UIFont.systemFont(ofSize: 15)
    datePicker.headersFont = UIFont.boldSystemFont(ofSize: 13)

    // Navigate with code
    datePicker.gotoNextMonth()    
    datePicker.gotoPreviousMonth()
```
please check sample project for more info.
