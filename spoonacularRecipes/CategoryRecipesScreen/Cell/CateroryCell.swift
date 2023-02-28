//
//  CateroryCell.swift
//  spoonacularRecipes
//
//  Created by Павел Грицков on 28.02.23.
//

import UIKit

class CateroryCell: UITableViewCell {
    
    private let offset: CGFloat = 20
    private let cellHeight: CGFloat = 200
    private let radius: CGFloat = 20
    
    let containerForlabel = UIView()
    let titleLabel = UILabel()
    let foodImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupFoodImageView()
        setupTitle()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods

extension CateroryCell {
    /// set titleLabel and image for imageView
    func configure(title text: String, and imageName: String) {
        titleLabel.text = text
        foodImageView.image = UIImage(named: imageName)
    }
}


// MARK: - Private methods

private extension CateroryCell {
    func setup() {
        // отключить выдиление ячейки (стиль выдиления)
        selectionStyle = .none
    }
    
    func setupTitle() {
        containerForlabel.backgroundColor = .black.withAlphaComponent(0.3)
        containerForlabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerForlabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.text = "CateroryCell"
        
        containerForlabel.addSubview(titleLabel)
    }
    
    func setupFoodImageView() {
        let foodImage = UIImage(named: "food")
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        foodImageView.contentMode = .scaleToFill
        foodImageView.image = foodImage
        foodImageView.layer.cornerRadius = radius
        foodImageView.clipsToBounds = true
        addSubview(foodImageView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            foodImageView.topAnchor.constraint(equalTo: topAnchor, constant: offset / 2),
            foodImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            self.trailingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: offset),
            foodImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            foodImageView.heightAnchor.constraint(equalToConstant: cellHeight),
        
            containerForlabel.topAnchor.constraint(equalTo: topAnchor, constant: 160),
            containerForlabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            self.trailingAnchor.constraint(equalTo: containerForlabel.trailingAnchor, constant: offset),
            containerForlabel.heightAnchor.constraint(equalToConstant: 30),
        
            titleLabel.heightAnchor.constraint(equalTo: containerForlabel.heightAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerForlabel.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerForlabel.leadingAnchor, constant: offset),
            titleLabel.trailingAnchor.constraint(equalTo: containerForlabel.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerForlabel.bottomAnchor)])
    }
}
