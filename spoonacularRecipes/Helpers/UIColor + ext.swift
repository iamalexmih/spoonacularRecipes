//
//  UIColor + ext.swift
//  spoonacularRecipes
//
//  Created by Павел Грицков on 10.03.23.
//

import UIKit

extension UIColor {
    static var orangeColor: UIColor {
        return UIColor(named: "orangeColor") ?? .orange
    }
    
    static var buttonColor: UIColor {
        return UIColor(named: "orangeColor") ?? .brown
    }
    
    static var blueColor: UIColor {
        return UIColor(named: "orangeColor") ?? .blue
    }
    
    static var blackTranslucent: UIColor {
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    static var selectBarIcon: UIColor {
        return .white
    }
    
    static var unselectBarIcon: UIColor {
        return #colorLiteral(red: 0.9978051782, green: 0.9287335873, blue: 0.8530223966, alpha: 1)
    }
}
