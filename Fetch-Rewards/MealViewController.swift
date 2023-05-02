//
//  MealViewController.swift
//  Fetch-Rewards
//
//  Created by Ayush Kadakia on 5/2/23.
//

import UIKit

class MealViewController: UIViewController {
    
///Properties
    
    var mealID: String?
    
    private var meal: Meal? {
        didSet {
            updateUI()
        }
    }
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private var mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private var mealNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var mealCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.text = "Ingredients"
        return label
    }()
    
    private var ingredientsTextLabel: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.numberOfLines = 0

        return textView
    }()
    
    private var instructionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.text = "Instructions"
        return label
    }()
    
    private var instructionsTextLabel: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.numberOfLines = 0
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mealImageView)
        contentView.addSubview(mealNameLabel)
        contentView.addSubview(mealCategoryLabel)
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(ingredientsTextLabel)
        contentView.addSubview(instructionsLabel)
        contentView.addSubview(instructionsTextLabel)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -16),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            mealImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mealImageView.heightAnchor.constraint(equalToConstant: 300),
            
            mealNameLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 16),
            mealNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mealNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            mealCategoryLabel.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 8),
            mealCategoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mealCategoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            instructionsLabel.topAnchor.constraint(equalTo: mealCategoryLabel.bottomAnchor, constant: 16),
            instructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            instructionsTextLabel.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 8),
            instructionsTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            instructionsTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ingredientsLabel.topAnchor.constraint(equalTo: instructionsTextLabel.bottomAnchor, constant: 16),
            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            ingredientsTextLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 8),
            ingredientsTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ingredientsTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ingredientsTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
        ])
        
        loadMeal()
    }
                
/// Helper Methods
    
    private func loadMeal() {
        guard let mealID = mealID else { return }
        
        APICaller.shared.fetchMealById(idMeal: mealID) { [weak self] result in
            switch result {
            case .success(let meal):
                self?.meal = meal
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
                
    private func updateUI() {
        guard let meal = meal else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.mealNameLabel.text = meal.strMeal
            strongSelf.mealCategoryLabel.text = meal.strCategory ?? ""
            strongSelf.mealImageView.downloadImage(from: meal.strMealThumb ?? "")
            strongSelf.instructionsTextLabel.text = meal.strInstructions

            
            var ingredientsAndMeasures = ""
            for IM in meal.ingredientsMeasures {
                ingredientsAndMeasures += "\(IM)\n"
            }
            
            strongSelf.ingredientsTextLabel.text = ingredientsAndMeasures
            
        }
    }
}

///I usually use SDWebImage, but requirement asked for UIImageView extension to download and cache the image data
extension UIImageView {
    
    func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)),
           let image = UIImage(data: cachedResponse.data) {
            self.image = image
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                  let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                return
            }
            
            let cacheResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cacheResponse, for: URLRequest(url: url))
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}

