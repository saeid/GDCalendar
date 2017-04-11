//
//  GDCalendar.swift
//  GDCalendar
//
//  Created by Saeid Basirnia on 4/11/17.
//  Copyright © 2017 Saeid Basirnia. All rights reserved.
//

import Foundation
import UIKit

//MARK: - main calendar view
class GDCalendar: UIView, UICollectionViewDelegate, UICollectionViewDataSource{
    //MARK: - vars
    private var cellSize: CGFloat = 35.0
    
    private var collectionView: UICollectionView{
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let cView: UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cView.semanticContentAttribute = .forceRightToLeft
        cView.backgroundColor = UIColor.white
        cView.allowsMultipleSelection = false
        cView.delegate = self
        cView.dataSource = self
        cView.register(GDCalendarItemCell.self, forCellWithReuseIdentifier: "cell")
        
        return cView
    }
    
    //MARK: - view setups
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cellSize = frame.width / 7
        self.createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.cellSize = frame.width / 7
        self.createViews()
    }
    
    func createViews(){
        self.addSubview(collectionView)
        self.datesArray = monthArray()
        self.generateHeaders()
        self.collectionView.reloadData()
    }
    
    //MARK: - date and inputs
    private var datesArray: [(date: Date, persianDay: Int)?] = []
    private let cal: Calendar = Date().defaultCalendar()
    private let today: Date = Date().today()
    private var startDate: Date = Date().startDayOfMonth()
    private let endDate: Date = Date().endDayOfMonth()
    private var dayNum = 0
    private var headers: [String] = []
    private var lastIndex: IndexPath? = nil

    //MARK: - funcs
    func generateHeaders(){
        for d in ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"]{
            self.headers.append(getTitle(dayName: d))
        }
        print(headers)
    }
    
    func monthArray() -> [(date: Date, persianDay: Int)?]{
        var dates: [(date: Date, persianDay: Int)?] = []
        dayNum = cal.component(.weekday, from: startDate)
        
        for _ in 0..<dayNum{
            dates.append(nil)
        }
        
        while endDate >= startDate{
            dates.append((startDate, startDate.componentsOfDate().2))
            self.startDate = cal.date(byAdding: .day, value: 1, to: startDate)!
        }
        return dates
    }
    
    func dayOfDate(date: Date) -> String{
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        return formatter.string(from: date)
    }
    
    
    //MARK: - convertors
    func getMonth(monthName: String) -> String{
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
    
    func getMonth(monthId: Int) -> String{
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
    
    func getTitle(dayName: String) -> String{
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
    
    func numsToPersian(num: String) -> String{
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = Locale(identifier: "fa_IR")
        formatter.number(from: num)
        
        return formatter.string(from: formatter.number(from: num)!)!
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
            cell.createCell(value: currTitle, size: cellSize, isHeader: true)
            cell.backgroundColor = UIColor.darkGray
        }else{
            guard let currDate = datesArray[indexPath.row] else{
                return cell
            }

            if currDate.date.isToday(date: today){
                cell.highlightCell()
                lastIndex = indexPath
            }
            cell.createCell(value: numsToPersian(num: String(currDate.persianDay)), size: cellSize, isHeader: false)
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
            cell.highlightCell()
            
            print(item)
        }
    }
}

//MARK: - collection view cell
class GDCalendarItemCell: UICollectionViewCell{
    var day: String = ""
    var size: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var headLabel: UILabel{
        let lbl: UILabel = UILabel()
        lbl.text = self.day
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        lbl.sizeToFit()
        lbl.frame = CGRect(x: 0, y: 0, width: self.size, height: self.size)
        
        return lbl
    }
    
    private var itemLabel: UILabel{
        let lbl: UILabel = UILabel()
        lbl.text = self.day
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        lbl.sizeToFit()
        lbl.frame = CGRect(x: 0, y: 0, width: self.size, height: self.size)
        
        return lbl
    }
    
    func createCell(value: String, size: CGFloat, isHeader: Bool){
        self.day = value
        self.size = size
        
        if isHeader{
            self.addSubview(headLabel)
        }else{
            self.layer.cornerRadius = self.frame.width / 2
            self.addSubview(itemLabel)
        }
    }
    
    func highlightCell(){
        self.backgroundColor = UIColor(red: 162 / 255, green: 0 / 255, blue: 10 / 255, alpha: 1.0)
        self.itemLabel.textColor = UIColor.white
    }
    
    func unhighlightCell(){
        self.backgroundColor = UIColor.clear
        self.itemLabel.textColor = UIColor.black
    }
}

//MARK: - date extension
extension Date{
    func defaultCalendar() -> Calendar{
        return Calendar(identifier: .persian)
    }
    
    func today() -> Date{
        let cal: Calendar = defaultCalendar()
        
        let comps: DateComponents = cal.dateComponents([.year, .month, .day], from: self)
        return cal.date(from: comps)!
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
    
    func dateWithOffset(value: Int) -> Date{
        let cal: Calendar = defaultCalendar()
        var comps: DateComponents = DateComponents()
        comps.month = value
        comps.day = -1
        
        return cal.date(byAdding: comps, to: self)!
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
