//
//  FavouritePlacesViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 5.01.24.
//

import UIKit

class FavouritePlacesViewController: UIViewController {

    func configure(with places: GetAllPlacesRequestResponseEntity){
        self.places = places
        tableView.reloadData()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    // MARK: - Private properties
    
    
    private lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .black
        refresh.addTarget(self, action: #selector(refreshFavouritePlaces), for: .valueChanged)
        return refresh
    }()
    
    private var places:GetAllPlacesRequestResponseEntity = []
    
    private let titleLabelView: UILabel = {
        let label = UILabel()

        label.text = "Любимые места"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black

        return label

    }()

    private lazy var tableView: SimilarPlacesTableView = {
        let tableView = SimilarPlacesTableView()

        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

}

// MARK: - Private methods
private extension FavouritePlacesViewController {
    func initialize(){
        view.backgroundColor = .white
        configNavigation()
        
        view.addSubview(tableView)
        
        tableView.addSubview(refresh)

        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
        }
        
        refreshFavouritePlaces()
    }
    
    func configNavigation() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItems = getLeftBarButtonItems()
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.titleView = titleLabelView
    }

    func getLeftBarButtonItems() -> [UIBarButtonItem] {
        var items = [UIBarButtonItem]()

        items.append(UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(back)))

        return items
    }

    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func openPlace(_ sender:UITapGestureRecognizer){
        if let cell = sender.view as? SimilarPlaceSingleCell{
            UserDefaults.standard.setValue(cell.placeId, forKey: "placeId")
            NotificationCenter.default.post(name: Notification.Name("findPlace"), object: nil)
        }
        
    }
    
    
    @objc func refreshFavouritePlaces() {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        FavouritePlacesNetworkManager.getFavouritePlacesForUser(id: userId) { [self] responseEntity in
            places = []
            if let response = responseEntity {

                for place in response.favPlaces {
                    places.append(place)
                }
            } else {
                print("error")
            }
            tableView.reloadData()
            refresh.endRefreshing()
        }
    }
}


// MARK: - UITableViewDataSource

extension FavouritePlacesViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SimilarPlaceSingleCell.self)) as! SimilarPlaceSingleCell

        cell.configure(with: places[index])
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPlace)))

        return cell
        }
    }


// MARK: - UITableViewDelegate

extension FavouritePlacesViewController: UITableViewDelegate {
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.alpha = 0

        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
        }
    }
}

