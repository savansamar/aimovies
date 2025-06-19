//
//import UIKit
//
//class Movies: UIViewController {
//    
//    // MARK: - Properties
//    private var movies: [Movie] = []
//    func movie(at index: Int) -> Movie {
//        return movies[index]
//    }
//    private var currentPage = 1
//    private var isPaginating = false
//    private var isLoading = false {
//        didSet {
//            collectionView.isHidden = isLoading
//            isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
//        }
//    }
//    
//    // MARK: - UI Components
//    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.estimatedItemSize = .zero
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.backgroundColor = .white
//        cv.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
//        cv.register(UICollectionReusableView.self,
//                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
//                    withReuseIdentifier: "footer")
//        cv.dataSource = self
//        cv.delegate = self
//        return cv
//    }()
//    
//    private let activityIndicator: UIActivityIndicatorView = {
//        let spinner = UIActivityIndicatorView(style: .large)
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        spinner.hidesWhenStopped = true
//        return spinner
//    }()
//    
//    private let header: Header = {
//        let header = Header()
//        header.translatesAutoresizingMaskIntoConstraints = false
//        return header
//    }()
//
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupLayout()
//        setupHeader()
//        
//        Task {
//            await loadUpcomingMovies()
//        }
//    }
//
//    // MARK: - Setup
//    private func setupLayout() {
//        view.addSubview(header)
//        view.addSubview(collectionView)
//        view.addSubview(activityIndicator)
//        
//        NSLayoutConstraint.activate([
//            header.topAnchor.constraint(equalTo: view.topAnchor),
//            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            header.heightAnchor.constraint(equalToConstant: 120),
//            
//            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    private func setupHeader() {
//        header.delegate = self
//        header.title = "Upcoming movies"
//        header.icon = UIImage(systemName: "person.circle")
//        header.rightIcon = UIImage(systemName: "person.circle")
//    }
//    
//    // MARK: - API
//    private func loadUpcomingMovies() async {
//        guard !isPaginating else { return }
//        isPaginating = true
//
//        if currentPage == 1 {
//            DispatchQueue.main.async {
//                self.isLoading = true
//            }
//        }
//
//        do {
//            let newMovies = try await MovieAPI.shared.fetchUpcomingMovies(page: currentPage)
//            DispatchQueue.main.async {
//                if self.currentPage == 1 {
//                    self.movies = newMovies
//                    self.collectionView.reloadData()
//                } else {
//                    let startIndex = self.movies.count
//                    let endIndex = startIndex + newMovies.count
//                    let indexPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
//
//                    self.movies.append(contentsOf: newMovies)
//                    self.collectionView.performBatchUpdates {
//                        self.collectionView.insertItems(at: indexPaths)
//                    }
//                }
//
//                self.isLoading = false
//
//                // Slight delay to allow footer loader to show smoothly
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                    self.isPaginating = false
//                    // Reload footer size if needed
//                    self.collectionView.collectionViewLayout.invalidateLayout()
//                }
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.showErrorAlert(message: "Failed to load movies. Please check your internet connection and try again.")
//                self.isLoading = false
//                self.isPaginating = false
//            }
//        }
//    }
//
//    // MARK: - Navigation
//    func goToMovieDetails(with movie: Movie) {
//        let root = MovieDetails()
//        root.movie = movie
//        root.modalPresentationStyle = .fullScreen
//        present(root, animated: true)
//    }
//
//    // MARK: - Error
//    private func showErrorAlert(message: String) {
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//}
//
//// MARK: - UICollectionViewDataSource
//extension Movies: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return movies.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let movie = movies[indexPath.row]
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
//        cell.configureCell(with: movie)
//        cell.delegate = self
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionFooter {
//            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
//                                                                         withReuseIdentifier: "footer",
//                                                                         for: indexPath)
//            footer.subviews.forEach { $0.removeFromSuperview() }
//
//            if isPaginating {
//                let spinner = UIActivityIndicatorView(style: .medium)
//                spinner.translatesAutoresizingMaskIntoConstraints = false
//                spinner.startAnimating()
//                footer.addSubview(spinner)
//
//                NSLayoutConstraint.activate([
//                    spinner.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
//                    spinner.centerYAnchor.constraint(equalTo: footer.centerYAnchor)
//                ])
//            }
//
//            return footer
//        }
//        return UICollectionReusableView()
//    }
//}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//extension Movies: UICollectionViewDelegateFlowLayout {
//    
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
//    }
//
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let spacing: CGFloat = 10
//        let sectionInsets: CGFloat = 20
//        let availableWidth = view.safeAreaLayoutGuide.layoutFrame.width - sectionInsets
//        let minItemsPerRow: CGFloat = 3
//        let desiredMinItemWidth: CGFloat = 100
//        let maxItemsPerRow = floor((availableWidth + spacing) / (desiredMinItemWidth + spacing))
//        let itemsPerRow = max(minItemsPerRow, maxItemsPerRow)
//        let totalSpacing = (itemsPerRow - 1) * spacing
//        let itemWidth = floor((availableWidth - totalSpacing) / itemsPerRow)
//        let itemHeight = itemWidth * 1.5
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        referenceSizeForFooterInSection section: Int) -> CGSize {
//        return isPaginating ? CGSize(width: collectionView.frame.width, height: 50) : .zero
//    }
//
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        willDisplay cell: UICollectionViewCell,
//                        forItemAt indexPath: IndexPath) {
//        if indexPath.row == movies.count - 1 && !isPaginating {
//            currentPage += 1
//            Task {
//                await loadUpcomingMovies()
//            }
//        }
//    }
//}
//




import UIKit

class Movies: UIViewController {

    // MARK: - Properties
    
    //  private(set) : - This protects write access while allowing read access from outside, But it can only be modified inside the Movies class. you can use private(set), but only for variables, not methods or computed properties.
    
    private(set) var movies: [Movie] = []
    var currentPage = 1
    var isPaginating = false
    var isLoading = false {
        didSet {
            collectionView.isHidden = isLoading
            isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }

    // MARK: - UI Components
    lazy var collectionView: UICollectionView = makeCollectionView()
    private lazy var  activityIndicator = makeActivityIndicator()
    private lazy var header = makeHeader()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupHeader()
        // makeheader is instance method , they only accessbile after self is full initlized
        // can be use here beacuse self is fully initlized while viewDidLoad
        // oither wise use lazy var
        
        // let header = makeHeader()
        
        Task {
            await loadUpcomingMovies()
        }
    }

    // MARK: - Setup
    private func setupLayout() {
        view.addSubview(header)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 120),

            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupHeader() {
        header.delegate = self
        header.title = "Upcoming movies"
        header.icon = UIImage(systemName: "person.circle")
        header.rightIcon = UIImage(systemName: "person.circle")
    }

    // MARK: - API
    func loadUpcomingMovies() async {
        guard !isPaginating else { return }
        isPaginating = true

        if currentPage == 1 {
            DispatchQueue.main.async {
                self.isLoading = true
            }
        }

        do {
            let newMovies = try await MovieAPI.shared.fetchUpcomingMovies(page: currentPage)
            DispatchQueue.main.async {
                if self.currentPage == 1 {
                    self.movies = newMovies
                    self.collectionView.reloadData()
                } else {
                    let startIndex = self.movies.count
                    let endIndex = startIndex + newMovies.count
                    let indexPaths = (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }

                    self.movies.append(contentsOf: newMovies)
                    self.collectionView.performBatchUpdates {
                        self.collectionView.insertItems(at: indexPaths)
                    }
                }

                self.isLoading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.isPaginating = false
                    self.collectionView.collectionViewLayout.invalidateLayout()
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.showErrorAlert(message: "Failed to load movies. Please check your internet connection.")
                self.isLoading = false
                self.isPaginating = false
            }
        }
    }

    // MARK: - Navigation
    func goToMovieDetails(with movie: Movie) {
        let detailsVC = MovieDetails()
        detailsVC.movie = movie
        detailsVC.modalPresentationStyle = .fullScreen
        present(detailsVC, animated: true)
    }

    func movie(at index: Int) -> Movie {
        return movies[index]
    }

    // MARK: - Error
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
