//
//  Array+Extensions.swift
//  spoonacularRecipes
//
//  Created by Eduard Tokarev on 09.03.2023.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
