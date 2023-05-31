//
//  SongCell.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import UIKit

final class SongCell: UITableViewCell {
    
    private let trackImage = UIImageView()
    private let artistLabel = UILabel()
    private let trackLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with model: SongModel) {
        artistLabel.text = model.artist
        trackLabel.text = model.track
        trackImage.image = model.imageMin
    }
    
    func updateImage(with image: UIImage?) {
        trackImage.image = image
    }
    
    private func setupUI() {
        backgroundColor = Resources.Colors.background
        
        trackImage.contentMode = .scaleAspectFill
        trackImage.clipsToBounds = true
        
        artistLabel.font = .boldSystemFont(ofSize: 16)
        artistLabel.numberOfLines = 0
        
        trackLabel.font = .systemFont(ofSize: 14)
        trackLabel.numberOfLines = 0
        
        [trackImage, artistLabel, trackLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            trackImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            trackImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trackImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            trackImage.widthAnchor.constraint(equalTo: trackImage.heightAnchor),
            
            artistLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            artistLabel.leadingAnchor.constraint(equalTo: trackImage.trailingAnchor, constant: 20),
            artistLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            trackLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 10),
            trackLabel.leadingAnchor.constraint(equalTo: artistLabel.leadingAnchor),
            trackLabel.trailingAnchor.constraint(equalTo: artistLabel.trailingAnchor),
            trackLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
