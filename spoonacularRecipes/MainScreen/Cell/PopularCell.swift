//
//  PopularCell.swift
//  spoonacularRecipes
//
//  Created by Nikita Zubov on 02.03.2023.
//

import UIKit
import Kingfisher

class PopularCell: UITableViewCell {
    private let offset: CGFloat = 20
    private let heightCell: CGFloat = 200
    private let radius: CGFloat = 20
    
    let titleLabel = UILabel()
    let foodImageView = UIImageView()
    let heartButton = UIButton(type: .system)
    let containerForCell = UIView()
    
    private var gradientView = GradientView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupImage()
        setupTitle()
        setupButton()
        setupContainer()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        
        gradientView = GradientView(frame: titleLabel.bounds)
    }
}

extension PopularCell {
    func configureCell(title: String, image: String) {
        titleLabel.text = title
        if !image.contains("https") {
            foodImageView.image = UIImage(named: "beverage")
        }
        else {
            let processor = RoundCornerImageProcessor(cornerRadius: 20)
            foodImageView.kf.setImage(with: URL(string: image), placeholder: UIImage(systemName: "xmark"),
            options: [
                .processor(processor),
                .transition(.fade(1))
            ])
        }
    }
}

//MARK: - Private Methods
extension PopularCell {
    func setup() {
        selectionStyle = .none
    }
    
    func setupContainer() {
        containerForCell.layer.cornerRadius = offset
        containerForCell.layer.masksToBounds = true
        containerForCell.translatesAutoresizingMaskIntoConstraints = false
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        containerForCell.addSubview(gradientView)
        contentView.addSubview(containerForCell)
    }
    
    func setupImage() {
        foodImageView.contentMode = .scaleToFill
        foodImageView.image = UIImage(named: "main course")
        foodImageView.layer.cornerRadius = radius
        foodImageView.clipsToBounds = true
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(foodImageView)
    }
    
    func setupButton() {
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.layer.cornerRadius = offset / 2
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        heartButton.tintColor = .white
        heartButton.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
        
        containerForCell.addSubview(heartButton)
    }
    
    @objc func heartButtonPressed(_ sender: UIButton) {
        animateButton(sender, playing: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animateButton(sender, playing: false)
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
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

extension PopularCell {
    private func animateButton(_ sender: UIButton, playing: Bool) {
        if playing {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: [.autoreverse, .repeat],
                           animations: { sender.alpha = 0.5 },
                           completion: nil)
        } else {
            UIView.animate(withDuration: 0.5,
                           animations: { sender.alpha = 1 },
                           completion: nil)
        }
    }
}

//MARK: - Constraints
extension PopularCell {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            foodImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset / 2),
            foodImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
            foodImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
            foodImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            foodImageView.heightAnchor.constraint(equalToConstant: heightCell)
        ])
        
        NSLayoutConstraint.activate([
            containerForCell.topAnchor.constraint(equalTo: foodImageView.topAnchor),
            containerForCell.bottomAnchor.constraint(equalTo: foodImageView.bottomAnchor),
            containerForCell.leadingAnchor.constraint(equalTo: foodImageView.leadingAnchor),
            containerForCell.trailingAnchor.constraint(equalTo: foodImageView.trailingAnchor)
        ])
               
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
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: containerForCell.topAnchor, constant: 160),
            gradientView.leadingAnchor.constraint(equalTo: containerForCell.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: containerForCell.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: containerForCell.bottomAnchor)
        ])
    }
}

