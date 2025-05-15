import UIKit

class MovieDetails: UIViewController {
    var movie:Movie?
    var currentIndexForSimilarMovies:Int = 0
    
    lazy var header: Header = {
        let view = Header()
        view.delegate = self
        view.title = "Movie Details"
        view.icon = UIImage(systemName: "arrow.backward")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()
    let root = PopularMovies()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupHeader()
        setupScrollView()
        setupPosterSection()
        setupTabSection()
        setupGenreAndReleaseSection()
        setupDescriptionSection()
    }

    // MARK: - Setup Header
    func setupHeader() {
        view.addSubview(header)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    // MARK: - ScrollView & StackView
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: header.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    
    func drawCircularProgress(on view: UIView, rating: CGFloat) {
        let center = CGPoint(x: 25, y: 25)
        let radius: CGFloat = 20
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi * (rating / 10.0) + startAngle

        // Track layer (gray circle)
        let trackLayer = CAShapeLayer()
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = trackPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 4
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)

        // Progress layer (green)
        let progressLayer = CAShapeLayer()
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer.path = progressPath.cgPath
        progressLayer.strokeColor = UIColor.systemGreen.cgColor
        progressLayer.lineWidth = 4
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        view.layer.addSublayer(progressLayer)
    }
    
    
    
    // MARK: - Poster Section
    func setupPosterSection() {
        let container = UIView()
        container.backgroundColor = .black
        container.heightAnchor.constraint(equalToConstant: 250).isActive = true
        

        let dummy = DiagonalView()
//        dummy.backgroundColor = .white
       
        dummy.translatesAutoresizingMaskIntoConstraints = false
       
        container.addSubview(dummy)

        // 🔧 Then apply constraints
        NSLayoutConstraint.activate([
            dummy.heightAnchor.constraint(equalToConstant: 250),
            dummy.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            dummy.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            dummy.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        

        // Background poster
        let backgroundPoster = UIImageView()
        backgroundPoster.contentMode = .scaleAspectFill
        backgroundPoster.clipsToBounds = true
        backgroundPoster.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(backgroundPoster)

        // Main poster
        let poster = UIImageView(image: UIImage(systemName: "photo"))
        poster.tintColor = .white
        poster.contentMode = .scaleAspectFit
        poster.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(poster)

        // Load image from URL
        if let path = movie?.posterPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        backgroundPoster.image = image
                        poster.image = image
                    }
                }
            }.resume()
        }

        // Movie title
        let titleLabel = UILabel()
        titleLabel.text = movie?.title ?? "Memory"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Circular Rating View
        let ratingContainer = UIView()
        ratingContainer.translatesAutoresizingMaskIntoConstraints = false
        ratingContainer.backgroundColor = .white
        ratingContainer.layer.cornerRadius = 25
        ratingContainer.clipsToBounds = true
        ratingContainer.widthAnchor.constraint(equalToConstant: 50).isActive = true
        ratingContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let ratingLabel = UILabel()
        let ratingValue = CGFloat(movie?.voteAverage ?? 7.3)
        ratingLabel.text = String(format: "%.1f", ratingValue)
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 14)
        ratingLabel.textColor = .black
        ratingLabel.textAlignment = .center
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingContainer.addSubview(ratingLabel)

        NSLayoutConstraint.activate([
            ratingLabel.centerXAnchor.constraint(equalTo: ratingContainer.centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingContainer.centerYAnchor)
        ])

        // Horizontal stack for title and rating
        let bottomStack = UIStackView(arrangedSubviews: [titleLabel, ratingContainer])
        bottomStack.axis = .horizontal
        bottomStack.alignment = .center
        bottomStack.spacing = 12
        bottomStack.distribution = .fill
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(bottomStack)

        // Draw Circular Progress
        drawCircularProgress(on: ratingContainer, rating: ratingValue)
        container.bringSubviewToFront(dummy)
        container.bringSubviewToFront(poster)
        container.bringSubviewToFront(bottomStack)
        // Constraints
        NSLayoutConstraint.activate([
            backgroundPoster.topAnchor.constraint(equalTo: container.topAnchor),
            backgroundPoster.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            backgroundPoster.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            backgroundPoster.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            poster.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            poster.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            poster.widthAnchor.constraint(equalToConstant: 100),
            poster.heightAnchor.constraint(equalToConstant: 150),

            bottomStack.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 10),
            bottomStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            bottomStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])

        contentStackView.addArrangedSubview(container)
    }
    
    
    func getSimilarMovies(current movieid:Int) async {
            do {
                currentIndexForSimilarMovies += 1
                let response = try await MovieAPI.shared.fetchSimilarMovies(movieId: movieid, page: currentIndexForSimilarMovies)
                root.movies.append(contentsOf: response)
                root.header_title = "Similar Movies"
                root.delegate = self
                root.reloadTable()
                root.modalPresentationStyle = .fullScreen
                present(root, animated: true)
               
                print("respons eof similar movies : \(response)")
            }
            catch {
                print("Error while get smilar movies")
            }
           
      
    }
    
    func handleTabTap(_ title: String) {
        
            guard let id = movie?.id else { return }
            
            if title == "Similars" {
                Task {
                    await getSimilarMovies(current: id)
                }
            }
            else if title == "Reviews" {
                let reviewController = ReviewController(movieID: id , movieName: movie?.title ?? "")
                reviewController.modalPresentationStyle = .fullScreen
                present(reviewController, animated: true)
//                let navController = UINavigationController(rootViewController: reviewController)
//                present(navController, animated: true, completion: nil)
            }
        else if title == "Trailers" {
            let reviewController = TrailerController(movieID: id , movieName: movie?.title ?? "")
            reviewController.modalPresentationStyle = .fullScreen
            present(reviewController, animated: true)
        }
        
    }

   
    func setupTabSection() {
        let tabStack = UIStackView()
        tabStack.axis = .horizontal
        tabStack.distribution = .fillEqually

        let tabs = [("star.fill", "Reviews"),
                    ("play.fill", "Trailers"),
                    ("person.3.fill", "Credits"),
                    ("film.fill", "Similars")]

        for (icon, title) in tabs {
            let tab = createTabItem(icon: icon, title: title) { [weak self] in
                self?.handleTabTap(title)
            }
            tabStack.addArrangedSubview(tab)
        }

        contentStackView.addArrangedSubview(tabStack)
    }

    func createTabItem(icon: String, title: String, action: @escaping () -> Void) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: icon)
        config.title = title
        config.imagePlacement = .top
        config.imagePadding = 4 // spacing between image and title
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4)

        let button = UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            action()
        }))

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    // MARK: - Genre & Release
    func setupGenreAndReleaseSection() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true

        let genre = UILabel()
        genre.text = "Genre\nAction, Crime, Thriller"
        genre.font = UIFont.boldSystemFont(ofSize: 14)
        genre.numberOfLines = 0

        let release = UILabel()
        release.text = "Release\n2022-04-28"
        release.font = UIFont.boldSystemFont(ofSize: 14)
        release.numberOfLines = 0

        stack.addArrangedSubview(genre)
        stack.addArrangedSubview(release)
        contentStackView.addArrangedSubview(stack)
    }

    // MARK: - Description
    func setupDescriptionSection() {
        let descriptionLabel = UILabel()
        descriptionLabel.text = movie?.overview
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let wrapper = UIView()
        wrapper.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 0),
            descriptionLabel.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -16)
        ])

        contentStackView.addArrangedSubview(wrapper)
    }
}

// MARK: - Header Delegate
extension MovieDetails: IconHeaderViewDelegate , PopularMoviesDelgates {
    func iconHeaderViewDidTapIcon() {
        dismiss(animated: true, completion: nil)
    }
    func onEndReached(title: String) {
        handleTabTap("Similars")
    }
}

