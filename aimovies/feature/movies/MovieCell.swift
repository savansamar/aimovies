
import UIKit

protocol MovieCellDelegate : AnyObject {
    func onTapImage(onCell cell: MovieCell)
}


class MovieCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MovieCell"
    weak var delegate : MovieCellDelegate?
   
    var movieId: Int?
    var imageUrl: String? = nil {
        didSet {
            guard let _ = imageUrl else {
                
                activityIndicator.stopAnimating()
                return
            }
           
            activityIndicator.stopAnimating()
        }
    }
    
    
    // UI Elements
    lazy var imageOfMovie: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
//        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .white
        iv.clipsToBounds = true
        return iv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    func setup() {
//        contentView.layer.borderColor = UIColor.red.cgColor
//        contentView.layer.borderWidth = 2
        contentView.addSubview(imageOfMovie)
        contentView.addSubview(activityIndicator)

        imageOfMovie.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageOfMovie.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageOfMovie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageOfMovie.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageOfMovie.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        addTapGesture()
    }
    
    // Configure cell with movie data (id and image URL)
    func configureCell(with movie: Movie) {
        self.movieId = movie.id
        self.imageUrl = movie.posterPath
        loadImage(from: movie.posterPath)
    }
    
    // Method to download image asynchronously
    private func loadImage(from path: String?) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        guard let path = path else { return }
        let urlString = "https://image.tmdb.org/t/p/w500\(path)"
        
        if let url = URL(string: urlString) {
            // Asynchronously download the image
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                   
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageOfMovie.image = image
                        self.imageUrl = nil
                    }
                }
            }.resume()
        }
    }
    
    private func addTapGesture() {
        imageOfMovie.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageOfMovie.addGestureRecognizer(tap)
    }

        @objc private func imageTapped() {
            // Animate the scale down and back up
            UIView.animate(withDuration: 0.1,
                           animations: {
                               self.imageOfMovie.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                           },
                           completion: { _ in
                               UIView.animate(withDuration: 0.1) {
                                   self.imageOfMovie.transform = .identity
                                   self.delegate?.onTapImage(onCell: self)
                                   
                               }
                           })
        }
}
