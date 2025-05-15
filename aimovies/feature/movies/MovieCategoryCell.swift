//
//  MovieCategoryCell.swift
//  aimovies
//
//  Created by MACM72 on 09/05/25.
//




import UIKit

class MovieCategoryCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MovieCategoryCell"
    
    var categoryName:String? = nil
    
    lazy var horizontalParentStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var firstStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 00, right: 00)
        return stack
    }()
    
    lazy var secondStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 00, right: 10)
        return stack
    }()
    
    
    let label1 = UILabel()
    
    lazy var dropButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.baseForegroundColor = .blue // This sets the image & title color

        let button = UIButton(configuration: config)
        button.tintColor = .blue
        button.backgroundColor = .clear // Optional safeguard
        button.addTarget(self, action: #selector(handleDropButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray // Choose your border color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleDropButtonTapped() {
        print("Drop button tapped")
    }
    
    func setConstraints(){
       
        label1.textAlignment = .center
        firstStack.addArrangedSubview(label1)
        secondStack.addArrangedSubview(dropButton)
        
        horizontalParentStack.translatesAutoresizingMaskIntoConstraints = false
           
        NSLayoutConstraint.activate([
            horizontalParentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalParentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalParentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalParentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalParentStack.heightAnchor.constraint(equalToConstant: 0),
            bottomBorder.heightAnchor.constraint(equalToConstant: 1),
            bottomBorder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bottomBorder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            bottomBorder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setUp(){
        
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        horizontalParentStack.addArrangedSubview(firstStack)
        horizontalParentStack.addArrangedSubview(secondStack)
        
        contentView.addSubview(horizontalParentStack)
        contentView.addSubview(bottomBorder)
        
        setConstraints()
    }
    
    func configureCell(with movie: Genre){
        
        self.categoryName = movie.name
        label1.text = movie.name
    }
    
}
