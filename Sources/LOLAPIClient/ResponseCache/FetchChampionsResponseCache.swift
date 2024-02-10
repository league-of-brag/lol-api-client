//
//  FetchChampionsResponseCache.swift
//
//
//  Created by Andreas Hård on 2024-02-03.
//

import Foundation
import Vapor

struct FetchChampionsResponseCache: CachedResponseItem {
    var requestURI: URI
    var eTag: String
    var response: ChampionsResponse
}
