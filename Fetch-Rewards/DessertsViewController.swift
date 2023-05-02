//
//  ViewController.swift
//  Fetch-Rewards
//
//  Created by Ayush Kadakia on 5/2/23.
//

import UIKit

class DessertsViewController: UIViewController {

    private var desserts = [Meal]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        loadDesserts()

    }
    
    private func loadDesserts() {
        APICaller.shared.fetchMeals { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch (result) {
            case .success(let meals):
                strongSelf.desserts = meals
            case .failure(_):
                print("error")
            }
        }
    }


}

///UITableViewDataSource

extension DessertsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return desserts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = desserts[indexPath.row].strMeal
        return cell
    }
}

///UITableViewDelegate

extension DessertsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMeal = desserts[indexPath.row]
        let mealVC = MealViewController()
        
        mealVC.modalPresentationStyle = .pageSheet

        mealVC.mealID = selectedMeal.idMeal
        present(mealVC, animated: true)
    }
}
