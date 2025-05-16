import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "MoviesCoreDataModel") // Use your .xcdatamodeld file name
        persistentContainer.loadPersistentStores { (desc, error) in
            if let error = error {
                fatalError("Failed to load Core Data store: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print("Failed to save Core Data context: \(error)")
            }
        }
    }
}
