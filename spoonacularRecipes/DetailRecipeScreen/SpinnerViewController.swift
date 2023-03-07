//
//  SpinnerViewController.swift
//  spoonacularRecipes
//
//  Created by Eduard Tokarev on 07.03.2023.
//

import UIKit

final class SpinnerViewController: UIViewController {
    private var spinner = UIActivityIndicatorView()
    
    override func loadView() {
        super.loadView()
        
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        spinner.style = UIActivityIndicatorView.Style.large
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
