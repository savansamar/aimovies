
import UIKit


// MARK: - MovieCellDelegate & Header Delegate
extension Movies: MovieCellDelegate, HeaderDelegate {
    func onTapImage(onCell cell: MovieCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let selectedMovie = movie(at: indexPath.item)
//            let selectedMovie = movies[indexPath.item]
            MovieManager.shared.addMovie(selectedMovie)
            goToMovieDetails(with: selectedMovie)
        }
    }

    func iconHeaderViewDidTapIcon() {
        AlertHelper.showErrorAlert(message: "Header icon tapped.",in: self)
    }
}


extension Movies : UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            movies.count
        }

        func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let movie = movie(at: indexPath.item)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
            cell.configureCell(with: movie)
            cell.delegate = self
            return cell
        }

        func collectionView(_ collectionView: UICollectionView,
                            viewForSupplementaryElementOfKind kind: String,
                            at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "footer",
                                                                             for: indexPath)
                footer.subviews.forEach { $0.removeFromSuperview() }

                if isPaginating {
                    let spinner = UIActivityIndicatorView(style: .medium)
                    spinner.translatesAutoresizingMaskIntoConstraints = false
                    spinner.startAnimating()
                    footer.addSubview(spinner)

                    NSLayoutConstraint.activate([
                        spinner.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
                        spinner.centerYAnchor.constraint(equalTo: footer.centerYAnchor)
                    ])
                }

                return footer
            }
            return UICollectionReusableView()
        }
    }

    extension Movies: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
            UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let spacing: CGFloat = 10
            let sectionInsets: CGFloat = 20
            let availableWidth = view.safeAreaLayoutGuide.layoutFrame.width - sectionInsets
            let minItemsPerRow: CGFloat = 3
            let desiredMinItemWidth: CGFloat = 100
            let maxItemsPerRow = floor((availableWidth + spacing) / (desiredMinItemWidth + spacing))
            let itemsPerRow = max(minItemsPerRow, maxItemsPerRow)
            let totalSpacing = (itemsPerRow - 1) * spacing
            let itemWidth = floor((availableWidth - totalSpacing) / itemsPerRow)
            let itemHeight = itemWidth * 1.5
            return CGSize(width: itemWidth, height: itemHeight)
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            referenceSizeForFooterInSection section: Int) -> CGSize {
            isPaginating ? CGSize(width: collectionView.frame.width, height: 50) : .zero
        }

        func collectionView(_ collectionView: UICollectionView,
                            willDisplay cell: UICollectionViewCell,
                            forItemAt indexPath: IndexPath) {
            if indexPath.item == movies.count - 1 && !isPaginating {
                currentPage += 1
                Task {
                    await loadUpcomingMovies()
                }
            }
        }
}
