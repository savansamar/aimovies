//
//  PopularMovies.swift
//  aimovies
//
//  Created by MACM72 on 12/05/25.
//


import UIKit

// Delegate protocol: describes what actions the header can notify
@objc protocol PopularMoviesDelgates: AnyObject {
    @objc func onEndReached(title:String)
}


class PopularMovies: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Delegate variable
    weak var delegate: PopularMoviesDelgates?
    
    let tableView = UITableView()
    var movies: [PopularMovie] = []
    var header_title: String = "" {
        didSet {
            header.title = header_title
        }
    }

    lazy var header: Header = {
        let view = Header()
        view.title = header_title // will be updated automatically by didSet
        view.icon = UIImage(systemName: "arrow.backward")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    func reloadTable(){
        tableView.reloadData()
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Popular Movies"
        view.backgroundColor = .white
        
        header.delegate = self
        view.addSubview(header)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(PopularMoviesCell.self, forCellReuseIdentifier: "PopularMoviesCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 120),
            
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularMoviesCell", for: indexPath) as! PopularMoviesCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Check if the last cell is being displayed
        if indexPath.row == movies.count - 1 {
            delegate?.onEndReached(title:header_title)
        }
    }
    
}

extension PopularMovies : IconHeaderViewDelegate {
    func iconHeaderViewDidTapIcon() {
        dismiss(animated: true, completion: nil)
    }
}
