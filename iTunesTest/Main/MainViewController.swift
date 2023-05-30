//
//  MainViewController.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let viewModel: MainViewModelProtocol
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let placeholder = UIActivityIndicatorView()
    private let errorMessage = UILabel()
    
    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupViews()
        setupConstraints()
    }
}

// MARK: - UI Settings

extension MainViewController {
    
    private func updateUI(for state: LoadingState) {
        switch state {
        case .idle:
            tableView.isHidden = true
        case .loading:
            placeholder.startAnimating()
            errorMessage.isHidden = true
            tableView.isHidden = true
        case .loaded:
            tableView.isHidden = false
            tableView.reloadData()
            placeholder.stopAnimating()
        case .failed(let errorText):
            errorMessage.isHidden = false
            errorMessage.text = errorText
            placeholder.stopAnimating()
        }
    }

    private func setupAppearance() {
        title = Constant.title
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = Resources.Colors.background
        
        tableView.backgroundColor = Resources.Colors.background
        
        errorMessage.textColor = .red
        errorMessage.font = .boldSystemFont(ofSize: 14)
    }
    
    private func setupViews() {
        [searchBar, tableView, placeholder, errorMessage].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SongCell.self, forCellReuseIdentifier: Resources.Identifiers.song)
        
        searchBar.delegate = self
        
        placeholder.hidesWhenStopped = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Resources.Identifiers.song,
            for: indexPath) as? SongCell
        else {
            fatalError("Failed to dequeue SongCell for identifier: \(Resources.Identifiers.song)")
        }
        
        let songModel = viewModel.music[indexPath.row]
        cell.setup(with: songModel)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextDidChange(searchText) { [weak self] loadingState in
            DispatchQueue.main.async {
                self?.updateUI(for: loadingState)
            }
        }
    }
}

// MARK: - Constant

extension MainViewController {
    struct Constant {
        static let title = "iTunes Search"
    }
}

