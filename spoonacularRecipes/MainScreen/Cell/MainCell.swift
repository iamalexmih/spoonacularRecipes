//
//  PopularCell.swift
//  spoonacularRecipes
//
//  Created by Nikita Zubov on 02.03.2023.
//

import UIKit
import Kingfisher

enum ButtonStatus {
    case off
    case on
}

protocol PopularCellDelegate {
    func didPressFavoriteButton(_ cell: MainCell, likeButton: UIButton, isFavorite status: Bool)
}

class MainCell: UITableViewCell {
    
    private let offset: CGFloat = 8
    private let radius: CGFloat = 20
    private let likeButtonSize: CGFloat = 30
    
    var isFavorite = false
    
    var delegate: PopularCellDelegate?
    
    private let mainContainer = UIView()
    
    let titleLabel = UILabel()
    let foodImageView = UIImageView()
    let heartButton = UIButton(type: .system)
    
    private let containerForlabel = UIView()
    private let topGradient = UIView()
    private var gradientView = GradientView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setupMainContainer()
        setupFoodImageView()
        setupContainerForLabel()
        configureGradientView()
        setupTopGradient()
        setupTitleLabel()
        setupHeartButton()
        setConstraints()
    }
    
    override func layoutSublayers(of layer: CALayer) {
            super.layoutSublayers(of: self.layer)
            gradientView = GradientView(frame: topGradient.bounds)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func heartButtonPressed(_ sender: UIButton) {
        
        // переключатель для кнопки
        if isFavorite {
            status(button: sender, turn: .off)
        } else {
            status(button: sender, turn: .on)
        }
        
        delegate?.didPressFavoriteButton(self, likeButton: sender, isFavorite: isFavorite)
//
//        if FavoriteRecipe.shared.favoriteListIdRecipe.contains(idRecipe) {
//
//            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
//
//            if let index = FavoriteRecipe.shared.favoriteListIdRecipe.firstIndex(of: idRecipe) {
//                FavoriteRecipe.shared.favoriteListIdRecipe.remove(at: index)
//            }
//
//        } else {
//            FavoriteRecipe.shared.favoriteListIdRecipe.append(idRecipe)
//            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        }
//
//        delegate?.didPressFavoriteButton(idRecipe)
//
//        DataManager.shared.save(favoriteRecipesID: FavoriteRecipe.shared.favoriteListIdRecipe)
    }
    
    
    func configureCell(title: String, imageName: String, isFavorite: Bool) {
        titleLabel.text = title
        foodImageView.kf.setImage(with: URL(string: imageName))
        self.isFavorite = isFavorite
                                  
        if self.isFavorite {
            status(button: heartButton, turn: .on)
        } else {
            status(button: heartButton, turn: .off)
        }
    }
    
    
    /// Меняет картинку на кнопке ячейки
    func status(button: UIButton, turn: ButtonStatus) {
        switch turn {
        case .on:
            let image = createImage(systemName: "heart.fill", andSize: likeButtonSize)
            button.setImage(image, for: .normal)
            isFavorite = true
        case .off:
            let image = createImage(systemName: "heart", andSize: likeButtonSize)
            button.setImage(image, for: .normal)
            isFavorite = false
        }
    }
}

//MARK: - Configure cell Appearance

private extension MainCell {
    
    func setupTopGradient() {
        topGradient.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(topGradient)
    }
    
    func configureGradientView() {
            gradientView.translatesAutoresizingMaskIntoConstraints = false
        }
    
    func setupContainerForLabel() {
        containerForlabel.translatesAutoresizingMaskIntoConstraints = false
        containerForlabel.backgroundColor = .blackTranslucent
        mainContainer.addSubview(containerForlabel)
    }
    
    func setupMainContainer() {
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.layer.cornerRadius = radius
        mainContainer.clipsToBounds = true
        contentView.addSubview(mainContainer)
    }
    
    func setupFoodImageView() {
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        foodImageView.contentMode = .scaleAspectFill
        foodImageView.image = UIImage(named: "main course")
        foodImageView.clipsToBounds = true
        
        mainContainer.addSubview(foodImageView)
    }
    
    func setupHeartButton() {
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        let image = createImage(systemName: "heart", andSize: likeButtonSize)
        heartButton.setImage(image, for: .normal)
        heartButton.tintColor = .white
        heartButton.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
        
        mainContainer.addSubview(heartButton)
    }
    
    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.text = "How to make yam & vegetable sauce at home"
        titleLabel.numberOfLines = 2
        
        containerForlabel.addSubview(titleLabel)
    }
    
    func createImage(systemName: String,andSize pointSize: CGFloat) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .regular, scale: .default)
        let image = UIImage(systemName: systemName, withConfiguration: config)
        return image
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset / 2),
            mainContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
            contentView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: offset),
            contentView.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: offset / 2),
            
            foodImageView.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            foodImageView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: foodImageView.trailingAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: foodImageView.bottomAnchor),
            
            containerForlabel.heightAnchor.constraint(equalTo: mainContainer.heightAnchor, multiplier: 0.2),
            containerForlabel.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: containerForlabel.trailingAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: containerForlabel.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerForlabel.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerForlabel.leadingAnchor, constant: 10),
            containerForlabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            containerForlabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            heartButton.heightAnchor.constraint(equalTo: mainContainer.heightAnchor, multiplier: 0.3),
            heartButton.widthAnchor.constraint(equalTo: mainContainer.heightAnchor, multiplier: 0.3),
            heartButton.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: heartButton.trailingAnchor),
            
            topGradient.heightAnchor.constraint(equalTo: heartButton.heightAnchor),
            topGradient.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            topGradient.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: topGradient.trailingAnchor),
        ])
    }
}


