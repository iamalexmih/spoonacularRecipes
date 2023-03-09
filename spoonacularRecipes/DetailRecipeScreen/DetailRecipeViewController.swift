//
//  DetailRecipeViewController.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 27.02.2023.
//

import UIKit
import Kingfisher

final class DetailRecipeViewController: UIViewController {
    var idRecipe: Int? = 715541
    private var source: DetailRecipeTodo?
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
    private let heartButton = UIButton(type: .system)
    
    private var isIngredients = true
    
    private let spinnerView = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setConstraints()
        loadData()
        setupTableView()
        actionButton()
        showSpinnerView()
        
        //TODO: Тестовый запрос для проверки работоспособности (Потом удалить)
        //            Этот тестовый метод писал Паша.
        // test
        //        if let id = idRecipe {
        //            NetworkService.shared.fetchRecipes(byIDs: [id]) { result in
        //                switch result {
        //                case .success(let data):
        //                    if let safeData = data as? [DetailRecipe],
        //                       let oneRecip = safeData.first {
        //                        let title = oneRecip.title
        //                        let min = oneRecip.readyInMinutes ?? 0
        //                        print("title = \(title), min = \(min)")
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
        paddingView.clipsToBounds = false
        paddingView.layer.cornerRadius = 25
        paddingView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupButton() {
        applyStyleButton(
            [ingredientsButton, instructionsButton],
            radius: 10
        )
        ingredientsButton.setTitle("Ingredient", for: .normal)
        instructionsButton.setTitle("Instructions", for: .normal)
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .default)
        let largeHeart = UIImage(systemName: "heart", withConfiguration: largeConfig)
        heartButton.setImage(largeHeart, for: .normal)
        heartButton.layer.cornerRadius = heartButton.frame.width / 2
        heartButton.layer.backgroundColor = UIColor(named: "orangeColor")?.cgColor
        heartButton.tintColor = #colorLiteral(red: 0.4521282315, green: 0, blue: 0, alpha: 1)
        heartButton.contentHorizontalAlignment = .center
        heartButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
    }
    
    func applyStyleButton(
        _ button: [UIButton],
        tintColor: UIColor = .white,
        backgroundColor: UIColor = UIColor(named: "buttonColor") ?? .clear,
        radius: CGFloat = 0
    ) {
        button.forEach { item in
            item.tintColor = tintColor
            item.backgroundColor = backgroundColor
            item.layer.cornerRadius = radius
        }
    }
    
    func setupTableView() {
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func loadData() {
        guard let idRecipe else { return }
        NetworkService.shared.fetchRecipes(byIDs: [idRecipe]) { result in
            switch result {
            case .success(let arrayWithOneRecipe):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else { return }
                    let recipe = arrayWithOneRecipe.first
                    guard let recipe else { return }
                    self.updateUI(recipe)
                    self.dismissSpinnerView()
                }
            case .failure(let error):
                self.showAlert(with: error)
            }
        }
    }
    
    func updateUI(_ recipe: DetailRecipe) {
        self.source = .init(from: recipe)
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        if let imageURLString = source?.image {
            let imageURL = URL(string: imageURLString)
            imageView.contentMode = .scaleAspectFill
            imageView.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "placeholder.jpg"),
                options: [
                    .processor(processor),
                    .transition(.fade(1))
                ]
            )
        }
        
        let minutes = String(source?.readyInMinutes ?? 0)
        readyLabel.text = "\(minutes) minutes"
        titleLabel.text = source?.title
        setupButton()
        tableView.reloadData()
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
        heartButton.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
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
    
    @objc func heartButtonPressed(_ sender: UIButton) {
        animateButton(sender, playing: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animateButton(sender, playing: false)
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    func animateButton(_ sender: UIButton, playing: Bool) {
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
    
    //MARK: - UIAlertController
    func showAlert(with error: Error) {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось загрузить рецепт. Ошибка - \(error)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    //MARK: - UIActivityIndicatorView
    func showSpinnerView() {
        addChild(spinnerView)
        spinnerView.view.frame = view.frame
        view.addSubview(spinnerView.view)
        spinnerView.didMove(toParent: self)
    }
    
    func dismissSpinnerView() {
        spinnerView.willMove(toParent: nil)
        spinnerView.view.removeFromSuperview()
        spinnerView.removeFromParent()
    }
    
    //MARK: - Constraints
    func setConstraints() {
        [imageView,
         paddingView,
         tableView,
         readyLabel,
         titleLabel,
         stackViewForButton,
         ingredientsButton,
         heartButton
        ]
            .forEach { item in
                item.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [imageView, paddingView, readyLabel].forEach { item in
            view.addSubview(item)
        }
        
        [heartButton, titleLabel, stackViewForButton, tableView].forEach { item in
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
            
            heartButton.centerYAnchor.constraint(equalTo: paddingView.topAnchor),
            heartButton.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -offset * 2),
            heartButton.heightAnchor.constraint(equalToConstant: 40),
            heartButton.widthAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: offset),
            titleLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -offset),
            titleLabel.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 25),
            
            stackViewForButton.heightAnchor.constraint(equalToConstant: 50),
            stackViewForButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            stackViewForButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            stackViewForButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            
            tableView.topAnchor.constraint(equalTo: stackViewForButton.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
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
            count = source?.ingredients?.count ?? 0
        } else {
            count = source?.analyzedInstructions?[safe: 0]?.steps?.count ?? 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var text = ""
        if isIngredients {
            text = source?.ingredients?[safe: indexPath.row]?.original ?? ""
            
            let isMarked = source?.ingredients?[safe: indexPath.row]?.isMarked
            cell.imageView?.image = isMarked ?? false
            ? UIImage(systemName: "checkmark.circle.fill")
            : UIImage(systemName: "circle")
            cell.imageView?.tintColor = UIColor(named: "orangeColor")
            
        } else {
            cell.imageView?.image = nil
            text = source?.analyzedInstructions?[safe: 0]?.steps?[safe: indexPath.row]?.step ?? ""
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = text
        return cell
    }
}

extension DetailRecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        
        if isIngredients {
            let isMarked = source?.ingredients?[safe: indexPath.row]?.isMarked
            
            guard let todos = source?.ingredients else { return }
            
            var todo = todos[safe: indexPath.row]!
            
            todo.isMarked = !(todo.isMarked ?? false)
            source?.ingredients?.remove(at: indexPath.row)
            source?.ingredients?.insert(todo, at: indexPath.row)
            
            cell.imageView?.image = isMarked ?? false
            ? UIImage(systemName: "circle")
            : UIImage(systemName: "checkmark.circle.fill")
            
            cell.imageView?.tintColor = UIColor(named: "orangeColor")
        }
    }
}
