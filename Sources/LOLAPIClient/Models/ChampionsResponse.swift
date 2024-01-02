//
//  ChampionsResponse.swift
//
//
//  Created by Andreas Hård on 2023-12-30.
//

import Foundation
import Vapor

typealias ChampionID = Int64

public struct ChampionsResponse: Content {
    public let type: String
    public let format: String
    public let version: String
    public let data: [ChampionID: ChampionDTO]
    
    enum CodingKeys: CodingKey {
        case type
        case format
        case version
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.format = try container.decode(String.self, forKey: .format)
        self.version = try container.decode(String.self, forKey: .version)
        let data: [String: ChampionDTO] = try container.decode([String : ChampionDTO].self, forKey: .data)
        self.data = Dictionary(uniqueKeysWithValues: data.values.map({ champion in
            return (champion.key, champion)
        }))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.format, forKey: .format)
        try container.encode(self.version, forKey: .version)
        let data: [String: ChampionDTO] = Dictionary(uniqueKeysWithValues: data.values.map({ champion in
            return (champion.name, champion)
        }))
        try container.encode(data, forKey: .data)
    }
}

struct ChampionDTO: Content {
    public let version: String
    public let id: String
    public let key: ChampionID
    public let name: String
    public let title: String
    public let blurb: String
    public let info: Info
    public let image: Image
    public let tags: [ChampionClass]
    public let partype: String
    public let stats: [String: Double]
    
    public var imageURLFormattedName: String {
        if let index: String.Index = name.firstIndex(of: "'") {
            let nextIndex: String.Index = name.index(after: index)
            let endIndex: String.Index = name.index(after: nextIndex)
            let lowercasedCharacter: String = name[nextIndex].lowercased()
            let emptyReplaceRange = index ..< nextIndex
            let lowercaseRange = nextIndex ..< endIndex
            return name
                .replacingCharacters(in: lowercaseRange, with: lowercasedCharacter)
                .replacingCharacters(in: emptyReplaceRange, with: "")
        } else {
            return name
        }
    }
    public var imageURL: URL {
        URL(string: "https://ddragon.leagueoflegends.com/cdn/13.24.1/img/champion/\(imageURLFormattedName).png")!
    }
    public var splashImageURL: URL {
        URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/loading/\(imageURLFormattedName)_0.jpg")!
    }
    
    enum CodingKeys: CodingKey {
        case version
        case id
        case key
        case name
        case title
        case blurb
        case info
        case image
        case tags
        case partype
        case stats
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.version = try container.decode(String.self, forKey: .version)
        self.id = try container.decode(String.self, forKey: .id)
        let key: String = try container.decode(String.self, forKey: .key)
        self.key = Int64(key)!
        self.name = try container.decode(String.self, forKey: .name)
        self.title = try container.decode(String.self, forKey: .title)
        self.blurb = try container.decode(String.self, forKey: .blurb)
        self.info = try container.decode(Info.self, forKey: .info)
        self.image = try container.decode(Image.self, forKey: .image)
        self.tags = try container.decode([ChampionClass].self, forKey: .tags)
        self.partype = try container.decode(String.self, forKey: .partype)
        self.stats = try container.decode([String : Double].self, forKey: .stats)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.version, forKey: .version)
        try container.encode(self.id, forKey: .id)
        let key: String = "\(self.key)"
        try container.encode(key, forKey: .key)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.blurb, forKey: .blurb)
        try container.encode(self.info, forKey: .info)
        try container.encode(self.image, forKey: .image)
        try container.encode(self.tags, forKey: .tags)
        try container.encode(self.partype, forKey: .partype)
        try container.encode(self.stats, forKey: .stats)
    }
}

struct Image: Content {
    public let full: String
    public let sprite: String
    public let group: String
    public let x: Int
    public let y: Int
    public let w: Int
    public let h: Int
}

struct Info: Content {
    public let attack: Int
    public let defense: Int
    public let magic: Int
    public let difficulty: Int
}
