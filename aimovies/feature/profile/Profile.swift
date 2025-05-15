//
//  Profile.swift
//  aimovies
//
//  Created by MACM72 on 05/05/25.
//

import UIKit

class Profile: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let sections = [
        ["Favorites", "Watchlist"],
        ["Recommendations", "Created Lists"]
    ]
    
    lazy var header: Header = {
        let view = Header()
        view.delegate = self
        view.title = "Account" // Updated title
        view.icon = UIImage(systemName: "arrow.backward")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupHeader() {
        view.addSubview(header)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        setupHeader() // ✅ Fix: Add the header before using it in constraints

        // TableView setup
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: Header Delegate
    func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count + 1 // +1 for sign out
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sections.count {
            return sections[section].count
        }
        return 1 // sign out
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if indexPath.section < sections.count {
            let title = sections[indexPath.section][indexPath.row]
            cell.textLabel?.text = title
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textColor = .label
        } else {
            cell.textLabel?.text = "Sign out"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .systemRed
            cell.accessoryType = .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == sections.count {
            print("Handle sign out")
        } else {
            let selected = sections[indexPath.section][indexPath.row]
            print("Selected: \(selected)")
        }
    }

    // MARK: Table Header (username section)
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = UIView()
            header.backgroundColor = .clear

            let usernameLabel = UILabel()
            usernameLabel.text = "DeluxeAlonso"
            usernameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            usernameLabel.textAlignment = .center

            let nameLabel = UILabel()
            nameLabel.text = "Alonso Alvarez"
            nameLabel.font = UIFont.systemFont(ofSize: 14)
            nameLabel.textColor = .gray
            nameLabel.textAlignment = .center

            let stack = UIStackView(arrangedSubviews: [usernameLabel, nameLabel])
            stack.axis = .vertical
            stack.spacing = 2
            stack.translatesAutoresizingMaskIntoConstraints = false

            header.addSubview(stack)
            NSLayoutConstraint.activate([
                stack.centerXAnchor.constraint(equalTo: header.centerXAnchor),
                stack.centerYAnchor.constraint(equalTo: header.centerYAnchor)
            ])

            return header
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 80 : 20
    }
}

extension Profile: IconHeaderViewDelegate {
    func iconHeaderViewDidTapIcon() {
        didTapBack() // Forward the call to the actual back handler
    }
}
