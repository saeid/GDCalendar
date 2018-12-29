# GDCalendar

Calendar component with both RTL/LTR languages support with Swipe Gesture enabled navigation.   
Easy to use with Storyboard and Attributes Inspector support.   


<img width="375" alt="screen shot 2017-04-13 at 01 42 00" src="https://cloud.githubusercontent.com/assets/9967486/24979816/e6595388-1fea-11e7-8b76-b2be3040e8e5.png">


## Requirements
- Xcode 10+
- Swift 4+
- iOS 8+


# Installation

## Cocoapods
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'GDCalendar'
end
```
    pod update
    pod install


## Usage
```swift
import GDCalendar
```

Set To Desire Locale Calendar
```swift
// Persian Calendar Locale: fa_IR
UserDefaults.standard.set("fa_IR", forKey: "current_locale")

// List of available iOS locale names
// https://gist.github.com/jacobbubu/1836273

/*
    If `current_locale` is not set, default phone calendar will be selected
*/
```

## Code
```swift
let calendar = GDTextSlot(frame: view.bounds)
view.addSubview(calendar)
```

Set Properties
```swift
// Days view items color
calendar.headerItemColor = UIColor.white
    
// Main calendar items text color
calendar.itemsColor = UIColor.black
    
// Header view items font
calendar.headersFont = UIFont.boldSystemFont(ofSize: 13)

// Calendar items font
calendar.itemsFont = UIFont.systemFont(ofSize: 15)
    
// Full properties list can be found on sample project

```

Set Date Selection Closure
```swift
calendar.dateSelectHandler = { [weak self] selectedDate in
    print(selectedDate)

    // Get Date Components
    let day = date.dayName
    let month = date.monthName
    
    let components = date.componentsOfDate
    print("\(components.year) / \(components.month) / \(components.day)")
}
```

## Storyboard
1) Add `UIView` to storyboard, set custom class to `GDCalendar`
2) Set attributes with `Attribute Inspector`


## Licence
GDCalendar is available under the MIT license. See the [LICENSE.txt](https://github.com/saeid/GDCalendar/blob/master/LICENSE) file for more info.