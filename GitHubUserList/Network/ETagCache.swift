//
//  ETagCache.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import Foundation

final class ETagCache {
    static let shared = ETagCache()
    private init() {}

    private let etagKeyPrefix = "etag_"
    private let dataKeyPrefix = "data_"

    func etag(for url: String) -> String? {
        UserDefaults.standard.string(forKey: etagKeyPrefix + url)
    }

    func data(for url: String) -> Data? {
        UserDefaults.standard.data(forKey: dataKeyPrefix + url)
    }

    func store(etag: String, data: Data, for url: String) {
        UserDefaults.standard.setValue(etag, forKey: etagKeyPrefix + url)
        UserDefaults.standard.setValue(data, forKey: dataKeyPrefix + url)
    }
    
    func deleteData(for url: String) {
        UserDefaults.standard.removeObject(forKey: etagKeyPrefix + url)
        UserDefaults.standard.removeObject(forKey: dataKeyPrefix + url)
    }
}
