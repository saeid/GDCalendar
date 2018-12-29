//
//  GDCalendarItemCell.swift
//  GDCalendar
//
//  Created by Saeid on 12/29/18.
//  Copyright © 2018 Saeid Basirnia. All rights reserved.
//

import UIKit

class GDCalendarItemCell: UICollectionViewCell{
    //MARK: - vars
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
    
    private func generateHeaderLabel(with text: String, color: UIColor, font: UIFont){
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = text
        headerLabel.font = font
        headerLabel.textColor = color
        headerLabel.textAlignment = .center
        headerLabel.sizeToFit()
        headerLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        if text.count > 1{
            headerLabel.transform = CGAffineTransform(rotationAngle: CGFloat((45 * Double.pi) / 180))
        }else{
            headerLabel.transform = .identity
        }
        
        addSubview(headerLabel)
        setConstraints(item: headerLabel)
    }
    
    private func generateItemLabel(with text: String, color: UIColor, font: UIFont){
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.text = text
        itemLabel.font = font
        itemLabel.textColor = color
        itemLabel.textAlignment = .center
        itemLabel.sizeToFit()
        itemLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        addSubview(itemLabel)
        setConstraints(item: itemLabel)
    }
    
    private func setConstraints(item: UILabel){
        item.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.0).isActive = true
        item.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
    }
    
    public func setupCell(value: String, headerBackColor: UIColor, headerItemColor: UIColor, headersFont: UIFont = UIFont.boldSystemFont(ofSize: 13)){
        backgroundColor = headerBackColor
        generateHeaderLabel(with: value, color: headerItemColor, font: headersFont)
    }
    
    public func setupCell(value: String, itemColor: UIColor, itemsFont: UIFont = UIFont.systemFont(ofSize: 15)){
        layer.cornerRadius = frame.width / 2
        generateItemLabel(with: value, color: itemColor, font: itemsFont)
    }
    
    public func highlightCell(highlightColor: UIColor, textColor: UIColor){
        UIView.animate(withDuration: 0.15) {
            self.backgroundColor = highlightColor
            self.itemLabel.textColor = textColor
        }
    }
    
    public func unhighlightCell(){
        UIView.animate(withDuration: 0.15) {
            self.backgroundColor = UIColor.clear
            self.itemLabel.textColor = UIColor.black
        }
    }
}
