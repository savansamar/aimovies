import UIKit

class Header: UIView, HeaderKeys {
    
    // MARK: - Properties
    weak var delegate: HeaderDelegate?
    var onIconTapped: (() -> Void)?

    var title: String = "" {
        didSet { titleLabel.text = title }
    }

    var icon: UIImage? = UIImage(systemName: "person.circle") {
        didSet {
            iconButton.setImage(icon ?? UIImage(systemName: "star.fill"), for: .normal)
        }
    }

    var rightIcon: UIImage? {
        didSet {
            rightIconImageView.image = rightIcon
        }
    }

    // MARK: - Views (lazy)

    private lazy var iconButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.setImage(icon, for: .normal)
        button.addTarget(self, action: #selector(handleLeftIconTap), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        return button
    }()

    private lazy var rightIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconButton, titleLabel, rightIconImageView])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .lightGray
        addSubview(containerView)
        containerView.addSubview(stackView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Actions

    @objc private func handleLeftIconTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.iconButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.iconButton.transform = .identity
                self.delegate?.headerDidTapLeftIcon(self)
                self.onIconTapped?()
            }
        })
    }
}
