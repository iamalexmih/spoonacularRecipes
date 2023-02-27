//
//  CateroryCell.swift
//  spoonacularRecipes
//
//  Created by Павел Грицков on 28.02.23.
//

import UIKit

class CateroryCell: UITableViewCell {
    
    let title = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods

extension CateroryCell {
    func configure(_ text: String) {
        title.text = text
    }
}


// MARK: - Private methods

private extension CateroryCell {
    func setup() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .black
        title.font = .boldSystemFont(ofSize: 22)
        title.textAlignment = .center
        title.text = "CateroryCell"
        addSubview(title)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
            title.heightAnchor.constraint(equalToConstant: 200)])
    }
}
