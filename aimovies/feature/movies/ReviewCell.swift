import UIKit


class ReviewCell: UITableViewCell {

    private let usernameLabel = UILabel()
    private let reviewLabel = UILabel()
    private let iconImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        usernameLabel.font = .boldSystemFont(ofSize: 16)
        reviewLabel.font = .systemFont(ofSize: 14)
        reviewLabel.numberOfLines = 0
        iconImageView.image = UIImage(systemName: "person.circle")
        iconImageView.tintColor = .darkGray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let hStack = UIStackView(arrangedSubviews: [usernameLabel, iconImageView])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center

        let vStack = UIStackView(arrangedSubviews: [hStack, reviewLabel])
        vStack.axis = .vertical
        vStack.spacing = 4
        vStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(with review: Review) {
        usernameLabel.text = review.username
        reviewLabel.text = review.content
    }
}
