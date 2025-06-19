import UIKit
import CoreData


class MovieManager {
    static let shared = MovieManager()
    
    let context = CoreDataManager.shared.context
//    let context = (UIApplication.shared.delegate as! CoreDataManager).persistentContainer.viewContext

    private(set) var movies: [Movie] = []

    private init() {
        loadMoviesFromCoreData()
    }
    
    func loadMoviesFromCoreData() {
        let fetchRequest: NSFetchRequest<MoviesDB> = MoviesDB.fetchRequest()
        
        do {
            if let result = try context.fetch(fetchRequest).first,
               let wrapper = result.moviesList {
                self.movies = wrapper.movies
                print("✅ Loaded \(movies) movies from Core Data.")
            } else {
                print("⚠️ No saved movies found in Core Data.")
            }
        } catch {
            print("❌ Failed to load movies from Core Data: \(error)")
        }
    }
    
    
    func deleteAllMovies() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MoviesDB.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            movies.removeAll()
            print("✅ All MoviesDB entries deleted successfully.")
        } catch {
            print("❌ Failed to delete MoviesDB entries: \(error)")
        }
    }

    func addMovie(_ movie: Movie) {
        
        // Step 1: Load existing movies from DB
        loadMoviesFromCoreData()
        
        // Step 2: Remove movie with same ID if it exists
        movies.removeAll { $0.id == movie.id }
        
        // Step 3: Add new movie to the beginning
        movies.insert(movie, at: 0)

        // Step 4: Save updated movies array to Core Data
        let fetchRequest: NSFetchRequest<MoviesDB> = MoviesDB.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            let db = results.first ?? MoviesDB(context: context)

            let wrapper = MovieListWrapper(movies: movies)
            db.moviesList = wrapper

            try context.save()
            print("✅ Movie saved and list updated.")
        } catch {
            print("❌ Failed to save movie to Core Data: \(error)")
        }
    }
    
    func addMovies(_ newMovies: [Movie]) {
        var seen = Set(movies.map { $0.id })
        movies += newMovies.filter { seen.insert($0.id).inserted }
    }

    func getReversedMovies() -> [Movie] {
        return movies
    }

    func clearMovies() {
        movies.removeAll()
    }
}
