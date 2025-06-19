import UIKit

extension Movies {

    // All are instance methods, because they are not marked as static or class
    
    
    
    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "footer")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }

    func makeActivityIndicator() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }

    func makeHeader() -> Header {
        let header = Header()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }
}
