//
//  MoviesDB+CoreDataProperties.swift
//  aimovies
//
//  Created by MACM72 on 16/05/25.
//
//

import Foundation
import CoreData


extension MoviesDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviesDB> {
        return NSFetchRequest<MoviesDB>(entityName: "MoviesDB")
    }

    @NSManaged internal var moviesList: MovieListWrapper?

}

extension MoviesDB : Identifiable {

}
