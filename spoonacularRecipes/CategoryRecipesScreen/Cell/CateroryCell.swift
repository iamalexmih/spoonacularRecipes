//
//  CateroryCell.swift
//  spoonacularRecipes
//
//  Created by Павел Грицков on 28.02.23.
//

import UIKit

final class CateroryCell: UITableViewCell {
    
    private let offset: CGFloat = 20
    private let cellHeight: CGFloat = 200
    private let radius: CGFloat = 20
    private var gradientView = GradientView()
    
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
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        
        gradientView = GradientView(frame: titleLabel.bounds)
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
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.text = "CateroryCell"
    }
    
    func setupFoodImageView() {
        let foodImage = UIImage(named: "food")
        foodImageView.contentMode = .scaleToFill
        foodImageView.image = foodImage
        foodImageView.layer.cornerRadius = radius
        foodImageView.clipsToBounds = true
    }
    
    func setConstraints() {
        [foodImageView, gradientView, titleLabel].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            foodImageView.topAnchor.constraint(equalTo: topAnchor, constant: offset / 2),
            foodImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            self.trailingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: offset),
            foodImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            foodImageView.heightAnchor.constraint(equalToConstant: cellHeight),
            
            gradientView.topAnchor.constraint(equalTo: topAnchor, constant: 160),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            self.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: offset),
            gradientView.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.heightAnchor.constraint(equalTo: gradientView.heightAnchor),
            titleLabel.topAnchor.constraint(equalTo: gradientView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: offset),
            titleLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor)
        ])
    }
}
