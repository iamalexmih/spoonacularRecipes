//
//  DetailRecipeViewController.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 27.02.2023.
//

import UIKit

final class DetailRecipeViewController: UIViewController {
    var idRecipe: Int? = 715541
    private var source: DetailRecipe?
    private let networkService = NetworkService()
    private let offset: CGFloat = 20
    
    private let tableView = UITableView()
    private let imageView = UIImageView()
    private let paddingView = UIView()
    
    private let stackViewButton = UIStackView()
    
    private let stackViewForButton: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    private let readyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let ingredientsButton = UIButton(type: .system)
    private let instructionsButton = UIButton(type: .system)
    private var isIngredients = true
    
    private let spinnerView = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        setConstraints()
        loadData()
        actionButton()
        showSpinnerView()
        
        //TODO: Тестовый запрос для проверки работоспособности (Потом удалить)
        // test
//        if let id = idRecipe {
//            networkService.fetchRecipes(byIDs: [id]) { result in
//                switch result {
//                case .success(let data):
//                    if let safeData = data as? [DetailRecipe],
//                        let oneRecip = safeData.first {
//                        let title = oneRecip.title
//                        let min = oneRecip.readyInMinutes ?? 0
//                            print("title = \(title), min = \(min)")
//                    }
//                case .failure(_):
//                    break
//                }
//            }
//        }
    }
}

private extension DetailRecipeViewController {
    func setup() {
        paddingView.backgroundColor = .white
        paddingView.clipsToBounds = true
        paddingView.layer.cornerRadius = 25
        paddingView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        tableView.dataSource = self
    }
    
    func setupButton() {
        applyStyleButton(
            [ingredientsButton, instructionsButton],
            radius: 10
        )
        ingredientsButton.setTitle("Ingredient", for: .normal)
        instructionsButton.setTitle("Instructions", for: .normal)
        
    }
    
    func loadData() {
        guard let idRecipe else { return }
        networkService.fetchRecipe(byID: idRecipe) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else { return }
                    self.source = data as? DetailRecipe
                    self.getImage(
                        urlString: self.source?.image,
                        completion: { image in
                        self.imageView.image = image
                    })
                    let minutes = String(self.source?.readyInMinutes ?? 0)
                    self.readyLabel.text = "\(minutes) minutes"
                    self.titleLabel.text = self.source?.title
                    self.setupButton()
                    self.tableView.reloadData()
                    self.dismissSpinnerView()
                }
            case .failure(_): break
            }
        }
    }

    func getImage(urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard
            let urlString,
            let url = URL(string: urlString)
        else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                    return completion(image)
            }
        } .resume()
    }
    
    func actionButton() {
        ingredientsButton.addTarget(self, action: #selector(ingredientsButtonTapped), for: .touchUpInside)
        instructionsButton.addTarget(self, action: #selector(instructionsButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func ingredientsButtonTapped() {
        isIngredients = true
        tableView.reloadData()
    }
    
    @objc
    func instructionsButtonTapped() {
        isIngredients = false
        tableView.reloadData()
    }
    
    func applyStyleButton(
        _ button: [UIButton],
        tintColor: UIColor = .white,
        backgroundColor: UIColor = #colorLiteral(red: 0.4470903873, green: 0.2713476717, blue: 0.009249448776, alpha: 1),
        radius: CGFloat = 0
    ) {
        button.forEach { item in
            item.tintColor = tintColor
            item.backgroundColor = backgroundColor
            item.layer.cornerRadius = radius
        }
    }
    
    func setConstraints() {
        [imageView,
         paddingView,
         tableView,
         readyLabel,
         titleLabel,
         stackViewForButton,
         ingredientsButton
        ]
            .forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [imageView, paddingView, readyLabel].forEach { item in
            view.addSubview(item)
        }
        
        [titleLabel, stackViewForButton, tableView].forEach { item in
            paddingView.addSubview(item)
        }
        
        [ingredientsButton, instructionsButton].forEach { item in
            stackViewForButton.addArrangedSubview(item)
        }
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250),

            readyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            readyLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -45),
            
            paddingView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -25),
            paddingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            paddingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: offset),
            titleLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -offset),
            titleLabel.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 25),
            
            stackViewForButton.heightAnchor.constraint(equalToConstant: 50),
            stackViewForButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            stackViewForButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            stackViewForButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            
            tableView.topAnchor.constraint(equalTo: stackViewForButton.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: offset),
            paddingView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: offset),
            tableView.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension DetailRecipeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if isIngredients {
            count = source?.extendedIngredients?.count ?? 0
        } else {
            count = source?.analyzedInstructions?[0].steps?.count ?? 0
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var text = ""
        if isIngredients {
            text = source?.extendedIngredients?[indexPath.row].original ?? ""
        } else {
            text = source?.analyzedInstructions?[0].steps?[indexPath.row].step ?? ""
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = text
        return cell
    }
    
    private func showSpinnerView() {
        addChild(spinnerView)
        spinnerView.view.frame = view.frame
        view.addSubview(spinnerView.view)
        spinnerView.didMove(toParent: self)
    }
    
    private func dismissSpinnerView() {
        spinnerView.willMove(toParent: nil)
        spinnerView.view.removeFromSuperview()
        spinnerView.removeFromParent()
    }
}
