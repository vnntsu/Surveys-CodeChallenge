//
//  Survey.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/24/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Foundation

final class Survey {
    let id: String
    let title: String
    let description: String
    let coverImageURL: String

    init(id: String, title: String, description: String, coverImageURL: String) {
        self.id = id
        self.title = title
        self.description = description
        self.coverImageURL = coverImageURL
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        coverImageURL = try container.decodeIfPresent(String.self, forKey: .coverImageURL) ?? ""
    }
}

// MARK: - Codable
extension Survey: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case coverImageURL = "cover_image_url"
    }
}
