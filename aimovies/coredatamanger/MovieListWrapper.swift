import Foundation

@objc(MovieListWrapper)
class MovieListWrapper: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true

    var movies: [Movie]

    init(movies: [Movie]) {
        self.movies = movies
    }

    required convenience init?(coder: NSCoder) {
        guard let data = coder.decodeObject(forKey: "movies") as? Data,
              let decoded = try? JSONDecoder().decode([Movie].self, from: data) else {
            return nil
        }
        self.init(movies: decoded)
    }

    func encode(with coder: NSCoder) {
        let data = try? JSONEncoder().encode(movies)
        coder.encode(data, forKey: "movies")
    }
}
