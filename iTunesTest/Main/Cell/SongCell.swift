//
//  SongCell.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import UIKit

final class SongCell: UITableViewCell {
    private let artistNameLabel = UILabel()
    private let trackNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with model: SongModel) {
        artistNameLabel.text = model.artist
        trackNameLabel.text = model.track
    }
    
    private func setupUI() {
        artistNameLabel.font = .boldSystemFont(ofSize: 16)
        
        trackNameLabel.font = .systemFont(ofSize: 14)
        
        [artistNameLabel, trackNameLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            artistNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            artistNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            trackNameLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 10),
            trackNameLabel.leadingAnchor.constraint(equalTo: artistNameLabel.leadingAnchor),
            trackNameLabel.trailingAnchor.constraint(equalTo: artistNameLabel.trailingAnchor),
            trackNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
