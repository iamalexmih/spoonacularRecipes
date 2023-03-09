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

class MainCell: UITableViewCell {
    
    private let offset: CGFloat = 20
    private let radius: CGFloat = 20
    private var idRecipe: Int = 0
    
    var delegate: PopularCellDelegate?
    
    private let mainContainer = UIView()
    
    let titleLabel = UILabel()
    let foodImageView = UIImageView()
    let heartButton = UIButton(type: .system)
//    private let containerForCell = UIView()
//    private var gradientView = GradientView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setupMainContainer()
        setupFoodImageView()
        setupTitleLabel()
        setupHeartButton()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSublayers(of layer: CALayer) {
//        super.layoutSublayers(of: self.layer)
//
//        gradientView = GradientView(frame: titleLabel.bounds)
//    }
    
    
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
        
        // включает и выключает лайк
        // TODO: сделать чтоб лайк отображался коректно после переиспользования ячейки
        if FavoriteRecipe.shared.favoriteListIdRecipe.contains(idRecipe) {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}


//MARK: - Configure cell Appearance

private extension MainCell {
    
    
//    func configureGradientView() {
//        gradientView.translatesAutoresizingMaskIntoConstraints = false
//    }
    
    
//    func setupContainerForCell() {
//        containerForCell.layer.cornerRadius = offset
//        containerForCell.layer.masksToBounds = true
//        containerForCell.translatesAutoresizingMaskIntoConstraints = false
//    }
    
    func setupMainContainer() {
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
//        mainContainer.layer.cornerRadius = radius / 2
//        mainContainer.layer.borderColor = UIColor.lightGray.cgColor
//        mainContainer.layer.borderWidth = 1
//        mainContainer.clipsToBounds = true
        contentView.addSubview(mainContainer)
    }
    
    func setupFoodImageView() {
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        foodImageView.contentMode = .scaleAspectFill
        foodImageView.image = UIImage(named: "main course")
        foodImageView.layer.cornerRadius = radius / 2
        foodImageView.clipsToBounds = true
        
        mainContainer.addSubview(foodImageView)
    }
    
    
    func setupHeartButton() {
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .heavy, scale: .large)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        
        heartButton.setImage(image, for: .normal)
        heartButton.tintColor = .orangeColor
        heartButton.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
        
        mainContainer.addSubview(heartButton)
    }
    
    
    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .darkGray
//        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.text = "How to make yam & vegetable sauce at home"
        titleLabel.numberOfLines = 2
        
        mainContainer.addSubview(titleLabel)
    }
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            mainContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            contentView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: 4),
            contentView.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: 2),
            
            foodImageView.widthAnchor.constraint(equalTo: mainContainer.heightAnchor),
            foodImageView.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            foodImageView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            foodImageView.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: 8),
            
            heartButton.widthAnchor.constraint(equalToConstant: 60),
            heartButton.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            heartButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4),
            heartButton.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            heartButton.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
            
        ])

    }
}


