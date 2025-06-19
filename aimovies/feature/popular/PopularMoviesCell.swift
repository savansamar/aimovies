//
//  PopularMoviesCell.swift
//  aimovies
//
//  Created by MACM72 on 12/05/25.
//

import UIKit



class PopularMoviesCell: UITableViewCell {
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    private let dateLabel = UILabel()
    private let ratingCircle = RatingView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 4
        
        ratingCircle.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 1

        genreLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.font = UIFont.systemFont(ofSize: 14)

        let stack = UIStackView(arrangedSubviews: [titleLabel, genreLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(posterImageView)
        contentView.addSubview(stack)
        contentView.addSubview(ratingCircle)

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 100),

            stack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: ratingCircle.leadingAnchor, constant: -12),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            ratingCircle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            ratingCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingCircle.widthAnchor.constraint(equalToConstant: 40),
            ratingCircle.heightAnchor.constraint(equalToConstant: 40),
        ])
    }


    func configure(with movie: PopularMovie) {
        // Load image asynchronously from URL if it exists
        if let posterPath = movie.posterImage,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        // Update the posterImageView with the fetched image
                        self.posterImageView.image = image
                    }
                }
            }.resume()
        }
        
        // Configure other labels and UI components
        titleLabel.text = movie.title
        genreLabel.text = movie.genre
        dateLabel.text = "Release date: \(movie.releaseDate)"
        ratingCircle.setRating(movie.rating)
    }
}
