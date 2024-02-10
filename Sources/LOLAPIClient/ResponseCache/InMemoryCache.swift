//
//  InMemoryCache.swift
//
//
//  Created by Andreas Hård on 2024-02-03.
//

import Foundation
import Vapor

protocol CachedResponseItem {
    associatedtype ResponseType: Codable
    
    var requestURI: URI { get }
    var eTag: String { get }
    var response: ResponseType { get }
}

class InMemoryCache {
    private(set) var cachedItems: [any CachedResponseItem] = []
    
    init() {
        
    }
    
    func cachedItem(for requestURI: URI) -> (any CachedResponseItem)? {
        guard let cachedItem = cachedItems
            .filter({ $0.requestURI.string == requestURI.string })
            .first else {
                return nil
            }
        return cachedItem
    }
    
    func addCachedItem(cachedItem: any CachedResponseItem) {
        if let cachedItemTuple = cachedItems
            .enumerated()
            .filter({ $0.element.requestURI.string == cachedItem.requestURI.string })
            .first {
            cachedItems.remove(at: cachedItemTuple.offset)
        }
        cachedItems.append(cachedItem)
    }
    
    func eTag(for requestURI: URI) -> String? {
        guard let cachedItem = cachedItem(for: requestURI) else {
            return nil
        }
        return cachedItem.eTag
    }
    
    
}
