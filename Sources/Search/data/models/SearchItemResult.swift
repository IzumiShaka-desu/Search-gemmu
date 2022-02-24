//
//  SearchItemResult.swift
//  gemmu
//
//  Created by Akashaka on 11/02/22.
//

public struct SearchItemResult: Codable {
    let slug, name: String
    let platforms: [Platform]
    let released: String?
    let backgroundImage: String?
    let rating: Double
    let ratingsCount, reviewsTextCount, added: Int
    let suggestionsCount: Int
    let updated: String
    let id: Int
    let score: String
    let reviewsCount: Int
    let genres: [GenreItem]

  public    enum CodingKeys: String, CodingKey {
        case slug, name, platforms, released
        case backgroundImage = "background_image"
        case rating
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added
        case suggestionsCount = "suggestions_count"
        case updated, id, score
        case reviewsCount = "reviews_count"
        case genres
    }
}
// MARK: - Genre
public struct GenreItem: Codable {
    let id: Int
    let name, slug: String
}

// MARK: - Platform
public struct Platform: Codable {
    let platform: GenreItem
}
public extension SearchItemResult {
  public func toEntity() -> SearchItemResultEntity {
    return SearchItemResultEntity(
      id: self.id,
      name: self.name ,
      imageUrl: self.backgroundImage ?? "",
      released: self.released ?? "",
      genres: self.extractGenreName()
    )
  }
  public  func extractPlatformsName() -> [String] {
        var results: [String]=[]
        for platform in self.platforms {
            results.append(platform.platform.slug)
        }
        return results
    }
  public   func extractGenreName() -> [String] {
        var results: [String]=[]
        for genre in self.genres {
            results.append(genre.name)
        }
        return results
    }

}
