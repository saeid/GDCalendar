//
//  GDCalendar.swift
//  GDCalendar
//
//  Created by Saeid Basirnia on 4/11/17.
//  Copyright © 2017 Saeid Basirnia. All rights reserved.
//

import Foundation
import UIKit

protocol GDCalendarDateDelegate{
    func onDateTap(date: Date)
}

//MARK: - main calendar view
class GDCalendar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate{
    //MARK: - vars
    public var headerBackgroundColor: UIColor = UIColor(red: 127 / 255, green: 124 / 255, blue: 118 / 255, alpha: 1.0)
    public var headerItemColor: UIColor = UIColor.white
    public var itemsColor: UIColor = UIColor.black
    
    public var itemHighlightColor: UIColor = UIColor(red: 162 / 255, green: 0 / 255, blue: 10 / 255, alpha: 1.0)
    public var itemHighlightTextColor: UIColor = UIColor.white
    
    public var topViewBackgroundColor: UIColor = UIColor.clear
    public var topViewItemColor: UIColor = UIColor.black
    
    public var delegate: GDCalendarDateDelegate? = nil
    
    private var cellSize: CGFloat = 35.0
    private var cView: UICollectionView!
    private var topView: UIView!
    private var topViewLabel: UILabel!
    
    
    //MARK: - view setups
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.createViews()
    }
    
    private func createViews(){
        self.cellSize = frame.width / 7
        self.initializeVars()

        self.generateMainCalendarView()
        
        self.generateHeaders()
        self.generateDates()
        self.createTopView()
    }
    
    private func createTopView(){
        topView = UIView()
        topView.backgroundColor = self.topViewBackgroundColor
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        topViewLabel = UILabel()
        topViewLabel.text = getCurrentMonthYearInfo()
        topViewLabel.font = UIFont.boldSystemFont(ofSize: 13)
        topViewLabel.textColor = self.topViewItemColor
        topViewLabel.sizeToFit()
        topViewLabel.textAlignment = .center
        topViewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topView.addSubview(topViewLabel)
        self.addSubview(topView)
        
        self.setTopViewConstraints(v: topView, l: topViewLabel)
        self.setCollectionViewConstraints()
    }
    
    private func setTopViewConstraints(v: UIView, l: UILabel){
        let centerX: NSLayoutConstraint = NSLayoutConstraint(item: l, attribute: .centerX, relatedBy: .equal, toItem: v, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerY: NSLayoutConstraint = NSLayoutConstraint(item: l, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        v.addConstraints([centerX, centerY])
        
        let top: NSLayoutConstraint = NSLayoutConstraint(item: v, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: v, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: v, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        let width: NSLayoutConstraint = NSLayoutConstraint(item: v, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.frame.width)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        
        self.addConstraints([top, left, right, height, width])
    }
    
    private func setCollectionViewConstraints(){
        let top: NSLayoutConstraint = NSLayoutConstraint(item: topView, attribute: .bottom, relatedBy: .equal, toItem: cView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: cView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: cView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: cView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        
        self.addConstraints([top, left, right, bottom])
    }
    
    private func generateDates(){
        self.datesArray = monthArray()
        self.cView.reloadSections([1])
    }
    
    private func generateMainCalendarView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        cView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cView.translatesAutoresizingMaskIntoConstraints = false
        cView.semanticContentAttribute = .forceRightToLeft
        cView.backgroundColor = UIColor.clear
        cView.allowsMultipleSelection = false
        cView.isUserInteractionEnabled = true
        cView.delegate = self
        cView.dataSource = self
        cView.register(GDCalendarItemCell.self, forCellWithReuseIdentifier: "cell")
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeLeft.direction = .left
        swipeLeft.delegate = self
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRight.direction = .right
        swipeRight.delegate = self
        
        cView.addGestureRecognizer(swipeLeft)
        cView.addGestureRecognizer(swipeRight)
        
        self.addSubview(cView)
    }
    
    private func initializeVars(){
        cal = Date().defaultCalendar()
        currentDate = Date().today()
        startDate = currentDate.startDayOfMonth()
        numberOfDaysInMonth = currentDate.daysIntMonth()
    }
    
    private func setDates(){
        startDate = currentDate.startDayOfMonth()
        numberOfDaysInMonth = currentDate.daysIntMonth()
    }
    
    //MARK: - date and inputs
    private var headers: [String] = []
    public var currentDate: Date!

    private var datesArray: [(date: Date, persianDay: Int)?] = []
    private var cal: Calendar!
    private var startDate: Date!
    private var numberOfDaysInMonth: Int = 0
    private var firstDayOfMonth = 0
    private var lastIndex: IndexPath? = nil
    
    //MARK: - funcs
    func didSwipe(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left{
            gotoPreviousMonth()
        }else if sender.direction == .right{
            gotoNextMonth()
        }
    }
    
    private func gotoNextMonth(){
        currentDate = self.currentDate.nextMonth()
        setDates()
        generateDates()
        
        topViewLabel.text = getCurrentMonthYearInfo()
    }
    
    private func gotoPreviousMonth(){
        currentDate = self.currentDate.previousMonth()
        setDates()
        generateDates()
        
        topViewLabel.text = getCurrentMonthYearInfo()
    }
    
    private func generateHeaders(){
        for d in ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"]{
            self.headers.append(getTitle(dayName: d))
        }
    }
    
    private func monthArray() -> [(date: Date, persianDay: Int)?]{
        self.datesArray.removeAll()
        
        var dates: [(date: Date, persianDay: Int)?] = []
        firstDayOfMonth = startDate.startingDayOfMonth()
        
        if firstDayOfMonth != 7{
            for _ in 0..<firstDayOfMonth{
                dates.append(nil)
            }
        }
        for _ in 0..<numberOfDaysInMonth{
            dates.append((startDate, startDate.componentsOfDate().2))
            self.startDate = cal.date(byAdding: .day, value: 1, to: startDate)!
        }
        return dates
    }
    
    
    //MARK: - convertors
    private func getMonth(monthName: String) -> String{
        switch monthName{
        case "Farvardin":
            return "فروردین"
        case "Ordibehesht":
            return "اردیبهشت"
        case "Khordad":
            return "خرداد"
        case "Tir":
            return "تیر"
        case "Mordad":
            return "مرداد"
        case "Shahrivar":
            return "شهریور"
        case "Mehr":
            return "مهر"
        case "Aban":
            return "آبان"
        case "Azar":
            return "آذر"
        case "Dey":
            return "دی"
        case "Bahman":
            return "بهمن"
        case "Esfand":
            return "اسفند"
        default:
            return ""
        }
    }
    
    private func getMonth(monthId: Int) -> String{
        switch monthId{
        case 1:
            return "فروردین"
        case 2:
            return "اردیبهشت"
        case 3:
            return "خرداد"
        case 4:
            return "تیر"
        case 5:
            return "مرداد"
        case 6:
            return "شهریور"
        case 7:
            return "مهر"
        case 8:
            return "آبان"
        case 9:
            return "آذر"
        case 10:
            return "دی"
        case 11:
            return "بهمن"
        case 12:
            return "اسفند"
        default:
            return ""
        }
    }
    
    private func getTitle(dayName: String) -> String{
        switch dayName {
        case "Sun":
            return "ی"
        case "Mon":
            return "د"
        case "Tue":
            return "س"
        case "Wed":
            return "چ"
        case "Thu":
            return "پ"
        case "Fri":
            return "ج"
        case "Sat":
            return "ش"
        default:
            return ""
        }
    }
    
    private func getCurrentMonthYearInfo() -> String{
        let dateComps = currentDate.componentsOfDate()
        let month = getMonth(monthId: dateComps.1)
        
        return "\(month) \(dateComps.year)".stringToPersian()
    }
    
    //MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return headers.count
        }else{
            return datesArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GDCalendarItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GDCalendarItemCell
        
        if indexPath.section == 0{
            let currTitle: String = self.headers[indexPath.row]
            cell.createCell(value: currTitle, size: cellSize, headerBackColor: headerBackgroundColor, headerItemColor: headerItemColor)
        }else{
            guard let currDate = datesArray[indexPath.row] else{
                cell.createCell(value: "", size: 0, itemColor: UIColor.clear)
                return cell
            }
            
            cell.createCell(value: String(currDate.persianDay).numsToPersian(), size: cellSize, itemColor: itemsColor)
            
            if currDate.date.isToday(date: Date().today()){
                cell.highlightCell(highlightColor: itemHighlightColor, textColor: itemHighlightTextColor)
                lastIndex = indexPath
            }else{
                cell.unhighlightCell()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            return
        }else{
            guard let item = datesArray[indexPath.row] else{
                return
            }
            
            if let index = lastIndex{
                let cellToClear: GDCalendarItemCell = collectionView.cellForItem(at: index) as! GDCalendarItemCell
                cellToClear.unhighlightCell()
            }
            lastIndex = indexPath
            let cell: GDCalendarItemCell = collectionView.cellForItem(at: indexPath) as! GDCalendarItemCell
            cell.highlightCell(highlightColor: itemHighlightColor, textColor: itemHighlightTextColor)
            
            self.currentDate = item.date
            self.delegate?.onDateTap(date: item.date)
        }
    }
}

//MARK: - collection view cell
class GDCalendarItemCell: UICollectionViewCell{
    
    //MARK: - vars
    private var day: String = ""
    private var size: CGFloat = 0.0
    private var itemColor: UIColor = UIColor.clear
    private var headerItemColor: UIColor = UIColor.clear
    private var headerLabel: UILabel!
    private var itemLabel: UILabel!
    
    
    //MARK: - cell view setups
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerLabel = UILabel()
        itemLabel = UILabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - label setups
    private func generateHeaderLabel(){
        headerLabel.text = self.day
        headerLabel.font = UIFont.boldSystemFont(ofSize: 13)
        headerLabel.textColor = self.headerItemColor
        headerLabel.textAlignment = .center
        headerLabel.sizeToFit()
        headerLabel.frame = CGRect(x: 0, y: 0, width: self.size, height: self.size)
    }
    
    private func generateItemLabel(){
        itemLabel.text = self.day
        itemLabel.font = UIFont.systemFont(ofSize: 15)
        itemLabel.textColor = self.itemColor
        itemLabel.textAlignment = .center
        itemLabel.sizeToFit()
        itemLabel.frame = CGRect(x: 0, y: 0, width: self.size, height: self.size)
    }
    
    fileprivate func createCell(value: String, size: CGFloat, headerBackColor: UIColor, headerItemColor: UIColor){
        self.day = value
        self.size = size
        self.headerItemColor = headerItemColor
        self.backgroundColor = headerBackColor
        
        self.generateHeaderLabel()
        self.addSubview(headerLabel)
    }
    
    fileprivate func createCell(value: String, size: CGFloat, itemColor: UIColor){
        self.day = value
        self.size = size
        self.itemColor = itemColor
        
        self.generateItemLabel()
        self.layer.cornerRadius = self.frame.width / 2
        self.addSubview(itemLabel)
    }
    
    fileprivate func highlightCell(highlightColor: UIColor, textColor: UIColor){
        self.backgroundColor = highlightColor
        self.itemLabel.textColor = textColor
    }
    
    fileprivate func unhighlightCell(){
        self.backgroundColor = UIColor.clear
        self.itemLabel.textColor = UIColor.black
    }
}

//MARK: - date extension
extension Date{
    func defaultCalendar() -> Calendar{
        var cal: Calendar = Calendar(identifier: .persian)
        cal.firstWeekday = 1
        
        return cal
    }
    
    func today() -> Date{
        let cal: Calendar = defaultCalendar()
        
        let comps: DateComponents = cal.dateComponents([.year, .month, .day], from: self)
        return cal.date(from: comps)!
    }
    
    func startingDayOfMonth() -> Int{
        let cal: Calendar = defaultCalendar()
        
        return cal.component(.weekday, from: self)
    }
    
    func startDayOfMonth() -> Date{
        let cal: Calendar = defaultCalendar()
        var comps: DateComponents = cal.dateComponents([.year, .month, .day], from: self)
        comps.setValue(1, for: .day)
        
        return cal.date(from: comps)!
    }
    
    func endDayOfMonth() -> Date{
        let cal: Calendar = defaultCalendar()
        
        return cal.date(byAdding: DateComponents(month: 1), to: startDayOfMonth())!
    }
    
    func date(year: Int, month: Int, day: Int) -> Date{
        let cal: Calendar = defaultCalendar()
        var comps: DateComponents = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        
        return cal.date(from: comps)!
    }
    
    func daysIntMonth() -> Int{
        let cal: Calendar = defaultCalendar()
        
        return cal.range(of: .day, in: .month, for: self)!.count
    }
    
    func componentsOfDate() -> (year: Int, month: Int, day: Int){
        let cal: Calendar = defaultCalendar()
        let comps = cal.dateComponents([.year, .month, .day], from: self)
        
        return (comps.year!, comps.month!, comps.day!)
    }
    
    func nextMonth() -> Date{
        let cal: Calendar = defaultCalendar()
        
        return cal.date(byAdding: DateComponents(month: 1), to: self)!
    }
    
    func previousMonth() -> Date{
        let cal: Calendar = defaultCalendar()
        
        return cal.date(byAdding: DateComponents(month: -1), to: self)!
    }
    
    func isToday(date: Date) -> Bool{
        let cal: Calendar = defaultCalendar()
        
        let result = cal.compare(self, to: date, toGranularity: .day)
        switch result{
        case .orderedSame:
            return true
        default:
            return false
        }
    }
}

//MARK: - string extension
extension String{
    func numsToPersian() -> String{
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = Locale(identifier: "fa_IR")
        
        return formatter.string(from: formatter.number(from: self)!)!
    }
    
    func stringToPersian() -> String{
        var output: String = ""
        
        for c in self.characters{
            switch c{
            case "1":
                output += "۱"
            case "2":
                output += "۲"
            case "3":
                output += "۳"
            case "4":
                output += "۴"
            case "5":
                output += "۵"
            case "6":
                output += "۶"
            case "7":
                output += "۷"
            case "8":
                output += "۸"
            case "9":
                output += "۹"
            case "0":
                output += "۰"
            default:
                output += String(c)
            }
        }
        return output
    }
}
