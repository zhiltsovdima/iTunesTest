//
//  DetailViewController.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 31.05.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let viewModel: DetailViewModelProtocol
    
    private let trackImage = UIImageView()
    private let placeholder = UIActivityIndicatorView()
    
    private let stackView = UIStackView()
    
    private let artistLabel = UILabel()
    private let trackName = UILabel()
    
    private let playButton = UIButton()
    private let progressBar = UIProgressView(progressViewStyle: .default)
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpdateCompletion()
        setupAppearance()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playButton.layer.cornerRadius = playButton.frame.height / 2
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    @objc private func playButtonTapped() {
        viewModel.playButtonTapped()
    }
    
    @objc private func backButtonTapped() {
        viewModel.backButtonTapped()
    }
}

// MARK: - UI Updating

extension DetailViewController {
    
    private func setUpdateCompletion() {
        viewModel.updateButtonCompletion = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateButton()
            }
        }
        viewModel.fetchImage { [weak self] state in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateUI(for: state)
            }
        }
        viewModel.updateProgressCompletion = { [weak self] progress in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateProgressBar(progress: progress)
            }
        }
        viewModel.setProgressUpdate()
    }
    
    private func updateUI(for state: LoadingState) {
        switch state {
        case .idle:
            break
        case .loading:
            placeholder.startAnimating()
        case .loaded:
            trackImage.image = viewModel.songModel.imageMax
            placeholder.stopAnimating()
        case .failed(_):
            trackImage.image = viewModel.songModel.imageMax
            placeholder.stopAnimating()
        }
    }
    
    private func updateButton() {
        let buttonImage = viewModel.isPlaying ? Resources.Images.pause : Resources.Images.play
        playButton.setImage(buttonImage, for: .normal)
    }
    
    private func updateProgressBar(progress: Float) {
        progressBar.progress = progress
    }
}

// MARK: - UI Settings

extension DetailViewController {
    
    private func setupAppearance() {
        view.backgroundColor = Resources.Colors.background
        navigationController?.navigationBar.tintColor = Resources.Colors.button
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Resources.Images.back,
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(backButtonTapped))
    }
    
    private func setupViews() {
        [trackImage, placeholder, stackView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        trackImage.contentMode = .scaleAspectFill
        trackImage.clipsToBounds = true
        
        artistLabel.text = viewModel.songModel.artist
        artistLabel.font = .boldSystemFont(ofSize: 20)
        artistLabel.textAlignment = .center
        artistLabel.numberOfLines = 0
        
        trackName.text = viewModel.songModel.track
        trackName.font = .systemFont(ofSize: 16)
        trackName.textAlignment = .center
        trackName.numberOfLines = 0
        
        playButton.setImage(Resources.Images.play, for: .normal)
        playButton.tintColor = .white
        playButton.backgroundColor = Resources.Colors.button
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
        
        [artistLabel, trackName, progressBar, playButton].forEach {
            stackView.addArrangedSubview($0)
        }
                
        placeholder.hidesWhenStopped = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            trackImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trackImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trackImage.heightAnchor.constraint(equalTo: trackImage.widthAnchor),

            placeholder.centerXAnchor.constraint(equalTo: trackImage.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: trackImage.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: trackImage.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: trackImage.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trackImage.trailingAnchor),
            
            progressBar.widthAnchor.constraint(equalTo: trackImage.widthAnchor),

            playButton.widthAnchor.constraint(equalToConstant: 70),
            playButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
