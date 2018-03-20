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
class GDCalendar: UIView, UIGestureRecognizerDelegate{
    //MARK: - vars
    public var headerBackgroundColor: UIColor = UIColor(red: 127 / 255, green: 124 / 255, blue: 118 / 255, alpha: 1.0)
    public var headerItemColor: UIColor = UIColor.white
    public var itemsColor: UIColor = UIColor.black
    
    public var itemHighlightColor: UIColor = UIColor(red: 162 / 255, green: 0 / 255, blue: 10 / 255, alpha: 1.0)
    public var itemHighlightTextColor: UIColor = UIColor.white
    
    public var topViewBackgroundColor: UIColor = UIColor.clear
    public var topViewItemColor: UIColor = UIColor.black
    
    public var dateSelectHandler: ((_ date: Date) -> ())? = nil
    public var itemsFont: UIFont = UIFont.systemFont(ofSize: 15)
    public var headersFont: UIFont = UIFont.boldSystemFont(ofSize: 13)
    
    fileprivate var cellSize: CGFloat = 35.0
    fileprivate var cView: UICollectionView!
    fileprivate var topView: UIView!
    fileprivate var topViewLabel: UILabel!
    
    fileprivate var direction: String = "ltr"
    
    //MARK: - view setups
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createViews()
    }
    
    fileprivate func createViews(){
        initializeVars()
        generateMainCalendarView()
        createTopView()
        generateHeaders()
        
        DispatchQueue.main.async {
            self.generateDates()
        }
    }
    
    fileprivate func createTopView(){
        topView = UIView()
        topView.backgroundColor = self.topViewBackgroundColor
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        topViewLabel = UILabel()
        topViewLabel.text = getCurrentMonthYearInfo()
        topViewLabel.font = self.headersFont
        topViewLabel.textColor = self.topViewItemColor
        topViewLabel.sizeToFit()
        topViewLabel.textAlignment = .center
        topViewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topView.addSubview(topViewLabel)
        self.addSubview(topView)
        
        self.setTopViewConstraints(v: topView, l: topViewLabel)
        self.setCollectionViewConstraints()
    }
    
    fileprivate func setTopViewConstraints(v: UIView, l: UILabel){
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
    
    fileprivate func setCollectionViewConstraints(){
        let top: NSLayoutConstraint = NSLayoutConstraint(item: topView, attribute: .bottom, relatedBy: .equal, toItem: cView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: cView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: cView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: cView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        
        self.addConstraints([top, left, right, bottom])
    }
    
    fileprivate func generateDates(){
        self.datesArray = monthArray()
        self.cView.reloadSections([1])
    }
    
    lazy private var layout: UICollectionViewFlowLayout = {
        let customLayout = UICollectionViewFlowLayout()
        customLayout.itemSize = CGSize(width: self.frame.width / 7, height: self.frame.width / 7)
        customLayout.minimumLineSpacing = 10
        customLayout.minimumInteritemSpacing = 0
        customLayout.scrollDirection = .vertical
        
        return customLayout
    }()
    private func setCollectionviewGestures(){
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeLeft.direction = .left
        swipeLeft.delegate = self
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRight.direction = .right
        swipeRight.delegate = self
        
        cView.addGestureRecognizer(swipeLeft)
        cView.addGestureRecognizer(swipeRight)
    }
    
    fileprivate func generateMainCalendarView(){
        cView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cView.translatesAutoresizingMaskIntoConstraints = false
        
        if direction == "rtl"{
            cView.semanticContentAttribute = .forceRightToLeft
        }
        cView.backgroundColor = UIColor.clear
        cView.allowsMultipleSelection = false
        cView.isUserInteractionEnabled = true
        cView.delegate = self
        cView.dataSource = self
        cView.register(GDCalendarItemCell.self, forCellWithReuseIdentifier: "cell")
        
        setCollectionviewGestures()
        addSubview(cView)
    }
    
    fileprivate func initializeVars(){
        cellSize = frame.width / 7
        cal = Date().currentCalendar
        currentDate = Date().today
        startDate = currentDate.startDayOfMonth
        numberOfDaysInMonth = currentDate.daysIntMonth
        
        var langCode = "en"
        if let lcode = cal.locale?.languageCode{
            langCode = lcode
        }
        direction = NSLocale.characterDirection(forLanguage: langCode).rawValue == 2 ? "rtl" : "ltr"
    }
    
    fileprivate func setDates(){
        startDate = currentDate.startDayOfMonth
        numberOfDaysInMonth = currentDate.daysIntMonth
    }
    
    //MARK: - date and inputs
    fileprivate var headers: [String] = []
    public var currentDate: Date!
    
    fileprivate var datesArray: [(date: Date, day: Int)?] = []
    fileprivate var cal: Calendar!
    fileprivate var startDate: Date!
    fileprivate var numberOfDaysInMonth: Int = 0
    fileprivate var firstDayOfMonth = 0
    fileprivate var lastIndex: IndexPath? = nil
    
    //MARK: - funcs
    func didSwipe(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left{
            gotoPreviousMonth()
        }else if sender.direction == .right{
            gotoNextMonth()
        }
    }
    
    public func gotoNextMonth(){
        currentDate = self.currentDate.nextMonth
        setDates()
        generateDates()
        
        topViewLabel.text = getCurrentMonthYearInfo()
    }
    
    public func gotoPreviousMonth(){
        currentDate = self.currentDate.previousMonth
        setDates()
        generateDates()
        
        topViewLabel.text = getCurrentMonthYearInfo()
    }
    
    private func generateHeaders(){
        let startDay = cal.firstWeekday
        if startDay == 7{
            var temp = Date().daysVeryShort
            let last = temp.popLast()!
            headers = temp
            headers.insert(last, at: 0)
        }else{
            headers = Date().days
        }
    }
    
    private func monthArray() -> [(date: Date, day: Int)?]{
        self.datesArray.removeAll()
        
        var dates: [(date: Date, day: Int)?] = []
        if direction == "rtl"{
            firstDayOfMonth = startDate.startingDayOfMonth
        }else{
            firstDayOfMonth = startDate.startingDayOfMonth - 1
        }
        for _ in 0..<firstDayOfMonth{
            dates.append(nil)
        }
        for _ in 0..<numberOfDaysInMonth{
            dates.append((startDate, startDate.componentsOfDate.2))
            self.startDate = cal.date(byAdding: .day, value: 1, to: startDate)!
        }
        return dates
    }
    
    private func getCurrentMonthYearInfo() -> String{
        let dateComps = currentDate.componentsOfDate
        let month = Date().months[dateComps.month - 1]
        
        return "\(month) \(dateComps.year)".convertNumbers
    }
    
}

//MARK: - collection view cell
class GDCalendarItemCell: UICollectionViewCell{
    //MARK: - vars
    private var day: String = ""
    private var size: CGFloat = 0.0
    private var itemColor: UIColor = UIColor.clear
    private var headerItemColor: UIColor = UIColor.clear
    private var itemsFont: UIFont!
    private var headersFont: UIFont!
    private var headerLabel: UILabel!
    private var itemLabel: UILabel!
    
    //MARK: - cell view setups
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initLabels()
    }
    
    //MARK: - label setups
    private func initLabels(){
        headerLabel = UILabel()
        itemLabel = UILabel()
    }
    
    private func generateHeaderLabel(){
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = self.day
        headerLabel.font = self.headersFont
        headerLabel.textColor = self.headerItemColor
        headerLabel.textAlignment = .center
        headerLabel.sizeToFit()
        headerLabel.frame = CGRect(x: 0, y: 0, width: self.size, height: self.size)
        if day.count > 1{
            headerLabel.transform = CGAffineTransform(rotationAngle: CGFloat((45 * Double.pi) / 180))
        }else{
            headerLabel.transform = .identity
        }
    }
    
    private func generateItemLabel(){
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.text = self.day
        itemLabel.font = self.itemsFont
        itemLabel.textColor = self.itemColor
        itemLabel.textAlignment = .center
        itemLabel.sizeToFit()
        itemLabel.frame = CGRect(x: 0, y: 0, width: self.size, height: self.size)
    }
    
    private func setConstraints(item: UILabel){
        item.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.0).isActive = true
        item.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
    }
    
    fileprivate func createCell(value: String, size: CGFloat, headerBackColor: UIColor, headerItemColor: UIColor, headersFont: UIFont = UIFont.boldSystemFont(ofSize: 13)){
        self.day = value
        self.size = size
        self.headerItemColor = headerItemColor
        self.headersFont = headersFont
        backgroundColor = headerBackColor
        
        generateHeaderLabel()
        addSubview(headerLabel)
        setConstraints(item: headerLabel)
    }
    
    fileprivate func createCell(value: String, size: CGFloat, itemColor: UIColor, itemsFont: UIFont = UIFont.systemFont(ofSize: 15)){
        self.day = value
        self.size = size
        self.itemColor = itemColor
        self.itemsFont = itemsFont
        
        generateItemLabel()
        layer.cornerRadius = self.frame.width / 2
        addSubview(itemLabel)
        setConstraints(item: itemLabel)
    }
    
    fileprivate func highlightCell(highlightColor: UIColor, textColor: UIColor){
        UIView.animate(withDuration: 0.15) {
            self.backgroundColor = highlightColor
            self.itemLabel.textColor = textColor
        }
    }
    
    fileprivate func unhighlightCell(){
        UIView.animate(withDuration: 0.15) {
            self.backgroundColor = UIColor.clear
            self.itemLabel.textColor = UIColor.black
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension GDCalendar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
                cell.unhighlightCell()
                
                return cell
            }
            
            cell.createCell(value: String(currDate.day).convertNumbers, size: cellSize, itemColor: itemsColor)
            
            if currDate.date.isToday(date: Date().today){
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
            if lastIndex == indexPath{
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
            dateSelectHandler?(item.date)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 7, height: frame.width / 7)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

//MARK: - string extension
extension String{
    var convertNumbers: String{
        var locale: Locale!
        if let localeString = UserDefaults.standard.object(forKey: "current_locale") as? String{
            locale = Locale(identifier: localeString)
        }else{
            locale = Locale.current
        }
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = locale
        
        var finalStr: String = ""
        for t in self{
            if let n = Int(String(t)){
                finalStr += formatter.string(from: NSNumber(integerLiteral: n))!
            }else{
                finalStr += String(t)
            }
        }
        return finalStr
    }
}
