//
//  SummonerDTO.swift
//
//
//  Created by Andreas Hård on 2023-12-27.
//

import Foundation
import Vapor

public struct SummonerDTO: Content {
    /// Encrypted account ID. Max length 56 characters
    public let accountId: String
    /// ID of the summoner icon associated with the summoner.
    public let profileIconId: Int
    /// Date summoner was last modified specified as epoch milliseconds. The following events will update this timestamp: summoner name change, summoner level change, or profile icon change.
    public let revisionDate: Date
    /// Summoner name.
    public let name: String
    /// Encrypted summoner ID. Max length 63 characters.
    public let id: String
    /// Encrypted PUUID. Exact length of 78 characters.
    public let puuid: String
    /// Summoner level associated with the summoner.
    public let summonerLevel: Int64
    
    public var profileIconImageURL: URL {
        return URL(string: "https://ddragon.leagueoflegends.com/cdn/13.24.1/img/profileicon/\(profileIconId).png")!
    }
}
