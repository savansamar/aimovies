import UIKit

class TrailerController: UIViewController {

    private var trailers: [Trailer] = []
    private let movieID: Int
    private let movieName: String

    private let tableView = UITableView()

    init(movieID: Int, movieName: String) {
        self.movieID = movieID
        self.movieName = movieName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var header: Header = {
        let view = Header()
        view.delegate = self
        view.icon = UIImage(systemName: "arrow.backward")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No trailers available."
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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = movieName
        view.backgroundColor = .white

        setupTableView()
        setupViews()

        header.title = movieName

        Task {
            await fetchTrailers()
        }
    }

    private func setupTableView() {
        tableView.register(TrailerCell.self, forCellReuseIdentifier: "TrailerCell")
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupViews() {
        view.addSubview(header)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 100),

            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchTrailers() async {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.emptyLabel.isHidden = true
            self.tableView.isHidden = true
        }

        do {
            let trailers = try await MovieAPI.shared.fetchMovieTrailers(movieID: movieID)
            DispatchQueue.main.async {
                self.trailers = trailers
                self.activityIndicator.stopAnimating()
                if trailers.isEmpty {
                    self.emptyLabel.isHidden = false
                } else {
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        } catch {
            print("Failed to load trailers: \(error)")
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.emptyLabel.text = "Failed to load trailers."
                self.emptyLabel.isHidden = false
            }
        }
    }
}

extension TrailerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trailers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trailer = trailers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerCell", for: indexPath) as! TrailerCell
        cell.configure(with: trailer)
        return cell
    }
}

extension TrailerController: IconHeaderViewDelegate {
    func iconHeaderViewDidTapIcon() {
        dismiss(animated: true, completion: nil)
    }
}
