//
//  Movies.swift
//  aimovies
//
//  Created by MACM72 on 05/05/25.
//

import UIKit

class Movies: UIViewController {
    
    var movies: [Movie] = []
    
    private var isLoading = false {
        didSet {
            // Update UI visibility based on loading state
            collectionView.isHidden = isLoading
            if isLoading {
//                showErrorAlert(message: "\(isLoading)")
                activityIndicator.startAnimating()
            } else {
//                showErrorAlert(message: "\(isLoading)")
                activityIndicator.stopAnimating()
            }
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        return cv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        Task {
            await loadUpcomingMovies()  // Calling the async method from a Task
        }
        
        setUp()
    }
    
    
    private func loadUpcomingMovies() async {
        
        DispatchQueue.main.async {
                self.isLoading = true
        }
        
        do {
            let movies = try await MovieAPI.shared.fetchUpcomingMovies()
            DispatchQueue.main.async {
                self.movies = movies
                self.isLoading = false
                self.collectionView.reloadData()
            }
        } catch let _ {
            DispatchQueue.main.async {
                self.showErrorAlert(message: "Failed to load movies. Please check your internet connection and try again.")
                self.isLoading = false
                
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
 
    
    func setUp() {
        let header = Header()
        header.delegate = self
        header.title = "Upcoming movies"
        header.icon = UIImage(systemName: "person.circle")
        header.rightIcon = UIImage(systemName: "person.circle")
       
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(header)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
       
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 120),
            
            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor,constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func goToMovieDetails(with movie: Movie) {
        DispatchQueue.main.async {
            let root = MovieDetails()
            root.movie = movie
            root.modalPresentationStyle = .fullScreen // optional
            self.present(root, animated: true, completion: nil)
        }
        
    }
    
}

extension Movies : UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count // Just for testing
       }

       func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let  movie = movies[indexPath.row]
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
                 cell.configureCell(with: movie)
                 cell.delegate = self
          return cell
       }

}

extension Movies: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = 10
          let sectionInsets: CGFloat = 20 // 10 left + 10 right
          let availableWidth = view.safeAreaLayoutGuide.layoutFrame.width - sectionInsets

          let minItemsPerRow: CGFloat = 3
          let desiredMinItemWidth: CGFloat = 100

          // Dynamically calculate how many items can fit (min 3)
          let maxItemsPerRow = floor((availableWidth + spacing) / (desiredMinItemWidth + spacing))
          let itemsPerRow = max(minItemsPerRow, maxItemsPerRow)

          let totalSpacing = (itemsPerRow - 1) * spacing
          let itemWidth = floor((availableWidth - totalSpacing) / itemsPerRow)
          let itemHeight = itemWidth * 1.5

          return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension Movies : MovieCellDelegate , IconHeaderViewDelegate {
    func onTapImage(onCell cell: MovieCell) {

           if let indexPath = collectionView.indexPath(for: cell) {
               let selectedMovie = movies[indexPath.item]
               MovieManager.shared.addMovie(selectedMovie)
               goToMovieDetails(with: selectedMovie)
               
           } else {
                print("Cell not found in the collection view.")
           }
    }
    
    func iconHeaderViewDidTapIcon() {
        showErrorAlert(message: "tab")
    }
    
}


