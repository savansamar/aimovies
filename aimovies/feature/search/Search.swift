import UIKit

class Search: UIViewController {

    var movieCategories:[Genre] = []
    var store_title : String = ""
    var currentPage = 0
    var isLoadingMore = false
    let root = PopularMovies()
    
    lazy var loaderOverlay: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = UIColor(white: 0, alpha: 0.4)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.isHidden = true

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false

        overlay.addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
        ])

        return overlay
    }()
    
    lazy var header: Header = {
        let view = Header()
        view.title = "Search Movies"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search"
        search.translatesAutoresizingMaskIntoConstraints = false

        if let textField = search.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .systemGray3
            textField.textColor = .black
            textField.layer.cornerRadius = 10
        }

        return search
    }()

    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var horizonatlCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 180)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        return collectionView
    }()

    lazy var collectionOfMoviesCategories: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 10 // Space below each cell
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0) // Optional padding

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCategoryCell.self, forCellWithReuseIdentifier: MovieCategoryCell.reuseIdentifier)
        return collectionView
    }()

    lazy var labelRecent: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "Recent Movies"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            container.heightAnchor.constraint(equalToConstant: 40)
        ])

        return container
    }()

    lazy var recentMovies: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(labelRecent)
        stack.addArrangedSubview(horizonatlCollectionView)
        return stack
    }()

    lazy var lableOfCategoriesMovies: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "Movies General"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            container.heightAnchor.constraint(equalToConstant: 40)
        ])

        return container
    }()

    lazy var stackofMoviesCategories: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(lableOfCategoriesMovies)
        return stack
    }()
    
    // Title + Subtitle Stack
     lazy var categoryInfoStack: UIStackView = {
         let stack = UIStackView()
         stack.axis = .vertical
         stack.alignment = .leading
         stack.distribution = .fill
         stack.spacing = 12
         stack.translatesAutoresizingMaskIntoConstraints = false
         return stack
     }()
     

    lazy var parentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
        stack.addArrangedSubview(recentMovies)
        stack.addArrangedSubview(categoryInfoStack)
        stack.addArrangedSubview(stackofMoviesCategories)
        stack.addArrangedSubview(collectionOfMoviesCategories)
        return stack
    }()
    
    private func addCategoryInfo(title: String, subtitle: String) {
        store_title = title
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .systemBlue
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTitleTap))
        titleLabel.addGestureRecognizer(tapGesture)

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .systemBlue
        subtitleLabel.numberOfLines = 1
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 4
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.addArrangedSubview(titleLabel)
//        verticalStack.addArrangedSubview(subtitleLabel)

        categoryInfoStack.addArrangedSubview(verticalStack)
        categoryInfoStack.addArrangedSubview(verticalStack)

        // Optional: Add separator below each info section
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        categoryInfoStack.addArrangedSubview(separator)
    }
    
 
    func getPopularMovies(type:String) async -> [PopularMovie]? {
        guard !isLoadingMore else { return nil }
        isLoadingMore = true
        currentPage += 1

        do {
            if type == "Popular movies"{
                let popular = try await MovieAPI.shared.fetchPopularMovies(page: currentPage)
                isLoadingMore = false
                return popular // Return the fetched movies
            }else{
                let popular = try await MovieAPI.shared.fetchTopRatedMovies(page: currentPage)
                isLoadingMore = false
                return popular // Return the fetched movies
            }
           
            
        } catch {
            print("Error: \(error)")
            isLoadingMore = false
            return nil // Return nil if there is an error
        }
    }
    
    
    func getMovies(_ type:String?) {
        showLoader()
        currentPage = 0
        
        if type == "Popular movies" {
            Task { [weak self] in
                guard let self = self else { return }
                
                if let response = await getPopularMovies(type: type ?? "") {
                    hideLoader()
                    root.movies.append(contentsOf: response)
                    root.header_title = "Popular movies"
                    root.delegate = self
                    root.reloadTable()
                    root.modalPresentationStyle = .fullScreen
                    present(root, animated: true)
                   
                } else {
                    
                    hideLoader()
                    print("Failed to fetch popular movies.")
                }
 
            }
        } else {
            Task {
                if let response = await getPopularMovies(type: type ?? "") {
                    hideLoader()
                    root.movies.append(contentsOf: response)
                    root.header_title = "Top rated movies"
                    root.delegate = self
                    root.reloadTable()
                    root.modalPresentationStyle = .fullScreen
                    present(root, animated: true)
                   
                } else {
                    hideLoader()
                    
                    print("Failed to fetch popular movies.")
                }
            }
        }
       
    }
    
    @objc private func handleTitleTap(_ sender: UITapGestureRecognizer) {
        if let label = sender.view as? UILabel {
            root.tableView.setContentOffset(.zero, animated: true)
            root.movies = []
            root.reloadTable()
            root.header_title = ""
            getMovies(label.text)
        }
    }
    
  
    private func getMovieCategories() async {
     
        do {
            let movies = try await MovieAPI.shared.fetchMovieeCategories()
            DispatchQueue.main.async {
                
                self.movieCategories = movies
                self.collectionOfMoviesCategories.reloadData()
            }
        } catch {
           print("while fetch movie categories : ")
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
        
        Task{
            await getMovieCategories()
        }

        addCategoryInfo(title: "Popular movies", subtitle: "The hottest movies on the internet")
        addCategoryInfo(title: "Top rated movies", subtitle: "The top rated movies on the internet")
        
        view.addSubview(loaderOverlay)
        view.addSubview(header)
        view.addSubview(searchBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(parentStack)

        parentStack.backgroundColor = .white
        recentMovies.backgroundColor = .white

        horizonatlCollectionView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        collectionOfMoviesCategories.heightAnchor.constraint(equalToConstant: 400).isActive = true
      
        setupConstraints()
    }

    func showLoader() {
        view.bringSubviewToFront(loaderOverlay)
        loaderOverlay.isHidden = false
    }

    func hideLoader() {
        loaderOverlay.isHidden = true
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            loaderOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loaderOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loaderOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loaderOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 120),

            searchBar.topAnchor.constraint(equalTo: header.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            parentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            parentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            parentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            parentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - Collection View Data Source and Delegate

extension Search: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == horizonatlCollectionView {
            return MovieManager.shared.getReversedMovies().count
        } else {
            return movieCategories.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       

        if collectionView == horizonatlCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
            let response = MovieManager.shared.getReversedMovies()
            let movie = response[indexPath.row]
            cell.configureCell(with: movie)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCategoryCell.reuseIdentifier, for: indexPath) as! MovieCategoryCell
            let categories = movieCategories[indexPath.row]
            cell.configureCell(with: categories)
            return cell
        }

        
    }
}

// MARK: - Tab Refreshable

extension Search: TabRefreshable , PopularMoviesDelgates {
    func didBecomeVisible() {
        recentMovies.isHidden = MovieManager.shared.getReversedMovies().isEmpty
        horizonatlCollectionView.reloadData()
    }
    func onEndReached(title: String) {
       
        getMovies(title)
    }
}
