//
//  PopularCell.swift
//  spoonacularRecipes
//
//  Created by Nikita Zubov on 02.03.2023.
//

import UIKit

class PopularCell: UITableViewCell {
    private let offset: CGFloat = 20
    private let heightCell: CGFloat = 200
    private let radius: CGFloat = 20
    
    let titleLabel = UILabel()
    let foodImageView = UIImageView()
    let heartButton = UIButton()
    let containerForCell = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupImage()
        setupContainer()
        setupTitle()
        setupButton()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PopularCell {
    func configureCell(title: String, image: String) {
        titleLabel.text = title
        foodImageView.image = UIImage(named: image)
    }
}

//MARK: - Private Methods
extension PopularCell {
    func setup() {
        selectionStyle = .none
    }
    
    func setupContainer() {
        //containerForCell.backgroundColor = .black.withAlphaComponent(0.3)
        containerForCell.layer.cornerRadius = offset
        containerForCell.translatesAutoresizingMaskIntoConstraints = false
        
//        let gradient = CAGradientLayer()
//        gradient.frame = containerForCell.frame
//        let first = (UIColor.clear).cgColor
//        let second = (UIColor.black).cgColor
//
//        gradient.colors = [first, second]
//        containerForCell.layer.insertSublayer(gradient, at: 0)
        
        //self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        addSubview(containerForCell)
    }
    
    func setupImage() {
        foodImageView.contentMode = .scaleToFill
        foodImageView.image = UIImage(named: "main course")
        foodImageView.layer.cornerRadius = radius
        foodImageView.clipsToBounds = true
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(foodImageView)
    }
    
    func setupButton() {
        heartButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.layer.cornerRadius = offset / 2
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerForCell.addSubview(heartButton)
    }
    
    func setupTitle() {
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.text = "How to make yam & vegetable sauce at home"
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerForCell.addSubview(titleLabel)
    }
}

//MARK: - Constraints
extension PopularCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            foodImageView.topAnchor.constraint(equalTo: topAnchor, constant: offset / 2),
            foodImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            foodImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset),
            foodImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            foodImageView.heightAnchor.constraint(equalToConstant: heightCell)
        ])
        
        NSLayoutConstraint.activate([
            containerForCell.topAnchor.constraint(equalTo: foodImageView.topAnchor),
            containerForCell.bottomAnchor.constraint(equalTo: foodImageView.bottomAnchor),
            containerForCell.leadingAnchor.constraint(equalTo: foodImageView.leadingAnchor),
            containerForCell.trailingAnchor.constraint(equalTo: foodImageView.trailingAnchor)
        ])
        
        let gradient = CAGradientLayer()
        gradient.frame = containerForCell.frame
        let first = (UIColor.clear).cgColor
        let second = (UIColor.black).cgColor

        gradient.colors = [first, second]
        containerForCell.layer.insertSublayer(gradient, at: 0)
        
        NSLayoutConstraint.activate([
            heartButton.topAnchor.constraint(equalTo: containerForCell.topAnchor, constant: offset/2),
            heartButton.trailingAnchor.constraint(equalTo: containerForCell.trailingAnchor, constant: -offset/2),
            heartButton.heightAnchor.constraint(equalToConstant: 30),
            heartButton.widthAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerForCell.topAnchor, constant: 160),
            titleLabel.leadingAnchor.constraint(equalTo: containerForCell.leadingAnchor, constant: offset),
            titleLabel.trailingAnchor.constraint(equalTo: containerForCell.trailingAnchor, constant: -offset),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
