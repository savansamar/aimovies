class MovieManager {
    static let shared = MovieManager()

    private(set) var movies: [Movie] = []

    private init() {}

    func addMovie(_ movie: Movie) {
        // Remove if already exists
        movies.removeAll { $0.id == movie.id }

        // Add to end
        movies.append(movie)
    }
    func addMovies(_ newMovies: [Movie]) {
        var seen = Set(movies.map { $0.id })
        movies += newMovies.filter { seen.insert($0.id).inserted }
    }

    func getReversedMovies() -> [Movie] {
        return movies.reversed()
    }

    func clearMovies() {
        movies.removeAll()
    }
}
