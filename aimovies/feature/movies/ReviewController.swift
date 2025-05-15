import UIKit

class ReviewController: UIViewController {

    let tableView = UITableView()
    private var reviews: [Review] = []
    private let movieID: Int
    private let movieName: String

    // MARK: - UI Elements

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No reviews available."
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    lazy var header: Header = {
        let view = Header()
        view.title = "Reviews"
        view.icon = UIImage(systemName: "arrow.backward")
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    init(movieID: Int, movieName: String) {
        self.movieID = movieID
        self.movieName = movieName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Task {
            await getReviews()
        }
    }

    // MARK: - Fetch Reviews

    func getReviews() async {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.emptyLabel.isHidden = true
            self.tableView.isHidden = true
        }

        do {
            let reviews = try await MovieAPI.shared.fetchMovieReviews(movieID: movieID)

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.reviews = reviews
                if reviews.isEmpty {
                    self.emptyLabel.text = "No reviews available."
                    self.emptyLabel.isHidden = false
                } else {
                    self.emptyLabel.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.emptyLabel.text = "Failed to load reviews."
                self.emptyLabel.isHidden = false
                self.tableView.isHidden = true
            }
            print("Error: \(error.localizedDescription)")
        }
    }

    // MARK: - Setup UI

    private func setupUI() {
        title = movieName
        view.backgroundColor = .white

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "ReviewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isHidden = true

        view.addSubview(header)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 120),

            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Table View

extension ReviewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.configure(with: reviews[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Header Delegate

extension ReviewController: IconHeaderViewDelegate {
    func iconHeaderViewDidTapIcon() {
        dismiss(animated: true, completion: nil)
    }
}
