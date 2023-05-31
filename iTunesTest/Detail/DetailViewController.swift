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
    private let artistLabel = UILabel()
    private let trackName = UILabel()
    
    private let playButton = UIButton()
    
    private let placeholder = UIActivityIndicatorView()
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        setupAppearance()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playButton.layer.cornerRadius = playButton.frame.height / 2
    }
    
    @objc private func playButtonTapped() {
        viewModel.playButtonTapped()
    }
}

extension DetailViewController {
    
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
        viewModel.isPlaying ? playButton.setImage(Resources.Images.pause, for: .normal) : playButton.setImage(Resources.Images.play, for: .normal)
    }
    
    private func setupAppearance() {
        view.backgroundColor = Resources.Colors.background
    }
    
    private func setupViews() {
        [trackImage, artistLabel, trackName, placeholder, playButton].forEach {
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
            
            artistLabel.topAnchor.constraint(equalTo: trackImage.bottomAnchor, constant: 20),
            artistLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            artistLabel.widthAnchor.constraint(equalTo: trackImage.widthAnchor),
            
            trackName.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 10),
            trackName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackName.widthAnchor.constraint(equalTo: trackImage.widthAnchor),
            
            playButton.topAnchor.constraint(equalTo: trackName.bottomAnchor, constant: 20),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 70),
            playButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
