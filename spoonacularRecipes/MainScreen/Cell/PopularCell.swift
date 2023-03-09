//
//  PopularCell.swift
//  spoonacularRecipes
//
//  Created by Nikita Zubov on 02.03.2023.
//

import UIKit
import Kingfisher


protocol PopularCellDelegate {
    func didPressFavoriteButton(_ idRecipe: Int)
}

class PopularCell: UITableViewCell {
    
    private let offset: CGFloat = 20
    private let heightCell: CGFloat = 200
    private let radius: CGFloat = 20
    private var idRecipe: Int = 0
    
    var delegate: PopularCellDelegate?
    
    let titleLabel = UILabel()
    private let foodImageView = UIImageView()
    private let heartButton = UIButton(type: .system)
    private let containerForCell = UIView()
    private var gradientView = GradientView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview()
        selectionStyleCell()
        setupImage()
        setupTitle()
        setupButton()
        setupContainerForCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        
        gradientView = GradientView(frame: titleLabel.bounds)
    }
    
    
    @objc func heartButtonPressed(_ sender: UIButton) {
        
        if FavoriteRecipe.shared.favoriteListIdRecipe.contains(idRecipe) {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            if let index = FavoriteRecipe.shared.favoriteListIdRecipe.firstIndex(of: idRecipe) {
                FavoriteRecipe.shared.favoriteListIdRecipe.remove(at: index)
            }
        } else {
            FavoriteRecipe.shared.favoriteListIdRecipe.append(idRecipe)
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        delegate?.didPressFavoriteButton(idRecipe)
        
        DataManager.shared.save(favoriteRecipesID: FavoriteRecipe.shared.favoriteListIdRecipe)
    }
    
    
    func configureCell(_ title: String, _ image: String, _ idRecipe: Int) {
        titleLabel.text = title
        self.idRecipe = idRecipe
        if !image.contains("https") {
            foodImageView.image = UIImage(named: "beverage")
        } else {
            foodImageView.kf.setImage(with: URL(string: image))
        }
        
        if FavoriteRecipe.shared.favoriteListIdRecipe.contains(idRecipe) {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}


//MARK: - Configure cell Appearance

private extension PopularCell {
    
    func selectionStyleCell() {
        selectionStyle = .none
        
    }
    
    
    func configureGradientView() {
        gradientView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func setupContainerForCell() {
        containerForCell.layer.cornerRadius = offset
        containerForCell.layer.masksToBounds = true
        containerForCell.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func setupImage() {
        foodImageView.contentMode = .scaleToFill
        foodImageView.image = UIImage(named: "main course")
        foodImageView.layer.cornerRadius = radius
        foodImageView.clipsToBounds = true
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func setupButton() {
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.layer.cornerRadius = offset / 2
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        heartButton.tintColor = .white
        heartButton.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
    }
    
    
    func setupTitle() {
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.text = "How to make yam & vegetable sauce at home"
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}


//MARK: - Layout

private extension PopularCell {
    func addSubview() {
        contentView.addSubview(foodImageView)
        contentView.addSubview(containerForCell)
        containerForCell.addSubview(gradientView)
        containerForCell.addSubview(titleLabel)
        containerForCell.addSubview(heartButton)
    }
    
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

