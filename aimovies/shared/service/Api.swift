import Foundation

struct Movie: Codable, Hashable {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    let genreIDs: [Int]  // Array of genre IDs

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"      // Map to "poster_path" in API response
        case overview
        case releaseDate = "release_date"    // Map to "release_date" in API response
        case voteAverage = "vote_average"    // Map to "vote_average" in API response
        case genreIDs = "genre_ids"          // Map to "genre_ids" in API response
    }

    // Hashable & Equatable (based on `id`)
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct GenresResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}


struct PopularMovie {
    let title: String
    let genre: String
    let releaseDate: String
    let rating: Double
    let posterImage: String?

}

struct Review {
    let username: String
    let content: String
}


struct TMDBReviewsResponse: Decodable {
    let results: [ReviewData]
}

struct ReviewData: Decodable {
    let author: String
    let content: String
}


struct Trailer: Decodable {
    let name: String
    let key: String

    var youtubeThumbnailURL: URL? {
        return URL(string: "https://img.youtube.com/vi/\(key)/0.jpg")
    }
}


struct TrailerResponse: Decodable {
    let results: [Trailer]
}



class MovieAPI {
    static let shared = MovieAPI()
    
    
    let apiKey = SecretsManager.shared.apiKey
    let baseURL = SecretsManager.shared.baseURL
  
    
    var genresMap: [Int: String] = [:]

    func fetchUpcomingMovies(page: Int) async throws -> [Movie] {
        guard let url = URL(string: "\(baseURL)/movie/upcoming?api_key=\(apiKey)&language=en-US&page=\(page)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decoded.results
    }
    

    func fetchMovieeCategories() async throws ->[Genre] {
        guard let url = URL(string: "\(baseURL)/genre/movie/list?api_key=\(apiKey)&language=en-US&page=1") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(GenresResponse.self, from: data)
        // Save mapping
        genresMap = Dictionary(uniqueKeysWithValues: decoded.genres.map { ($0.id, $0.name) })
        return decoded.genres
    }
    
    func genreNames(for ids: [Int]) -> [String] {
           return ids.compactMap { genresMap[$0] }
       }
    
    func fetchMovies(endpoint: String, page: Int = 1) async throws -> [PopularMovie] {
        // Construct the URL for the API endpoint (either popular or top-rated)
        
     
        guard let url = URL(string: "\(baseURL)/movie/\(endpoint)?api_key=\(apiKey)&language=en-US&page=\(page)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)

        var movies: [PopularMovie] = []

        for movie in decoded.results {
            let genreNames = genreNames(for: movie.genreIDs)
            let popularMovie = PopularMovie(
                title: movie.title,
                genre: genreNames.joined(separator: ", "),
                releaseDate: movie.releaseDate,
                rating: movie.voteAverage,
                posterImage: movie.posterPath
            )

            movies.append(popularMovie)
        }

        return movies
    }
    
    
    func fetchSimilarMovies(movieId: Int, page: Int = 1) async throws -> [PopularMovie] {
        guard let url = URL(string: "\(baseURL)/movie/\(movieId)/similar?api_key=\(apiKey)&language=en-US&page=\(page)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)

        var movies: [PopularMovie] = []

        for movie in decoded.results {
            let genreNames = genreNames(for: movie.genreIDs)
            let popularMovie = PopularMovie(
                title: movie.title,
                genre: genreNames.joined(separator: ", "),
                releaseDate: movie.releaseDate,
                rating: movie.voteAverage,
                posterImage: movie.posterPath
            )
            movies.append(popularMovie)
        }

        return movies
    }
    
    

    func fetchPopularMovies(page: Int = 1) async throws -> [PopularMovie] {
        return try await fetchMovies(endpoint: "popular", page: page)
    }

    func fetchTopRatedMovies(page: Int = 1) async throws -> [PopularMovie] {
        return try await fetchMovies(endpoint: "top_rated", page: page)
    }
    
    
    func fetchMovieReviews(movieID: Int) async throws -> [Review] {
           let urlString = "\(baseURL)\(movieID)/reviews?api_key=\(apiKey)"
           guard let url = URL(string: urlString) else {
               throw URLError(.badURL)
           }

           let (data, _) = try await URLSession.shared.data(from: url)
           let decoded = try JSONDecoder().decode(TMDBReviewsResponse.self, from: data)
           return decoded.results.map { Review(username: $0.author, content: $0.content) }
    }
    
    func fetchMovieTrailers(movieID: Int) async throws -> [Trailer] {
            
            let urlString = "\(baseURL)\(movieID)/videos?api_key=\(apiKey)&language=en-US"
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }

            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(TrailerResponse.self, from: data)
            return decoded.results.filter { $0.name.lowercased().contains("trailer") || $0.name.lowercased().contains("video") }
        }
    
    
    func fetchMoviesByGenre(genreID: Int, page: Int = 1) async throws -> [PopularMovie] {
        guard let url = URL(string: "\(baseURL)/discover/movie?api_key=\(apiKey)&language=en-US&page=\(page)&with_genres=\(genreID)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)

        var movies: [PopularMovie] = []

        for movie in decoded.results {
            let genreNames = genreNames(for: movie.genreIDs)
            let popularMovie = PopularMovie(
                title: movie.title,
                genre: genreNames.joined(separator: ", "),
                releaseDate: movie.releaseDate,
                rating: movie.voteAverage,
                posterImage: movie.posterPath
            )
            movies.append(popularMovie)
        }

        return movies
    }
    
}
