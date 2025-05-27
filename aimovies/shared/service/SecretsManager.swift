import UIKit
import Foundation

final class SecretsManager {
    static let shared = SecretsManager()
    private var secrets: [String: Any] = [:]


    private(set) var apiKey: String = ""
    private(set) var baseURL: String = ""

    private init() {
        loadSecrets()
    }

    private func loadSecrets() {
        guard let configPlistName = Bundle.main.infoDictionary?["CONFIG_PLIST_NAME"] as? String else {
            print("❌ CONFIG_PLIST_NAME not found or not a string")
            return
        }
        print("🔍 CONFIG_PLIST_NAME = \(configPlistName)")

        guard let path = Bundle.main.path(forResource: configPlistName, ofType: "plist") else {
            print("❌ Plist file '\(configPlistName).plist' not found in bundle")
            return
        }
        print("📍 Found plist at path: \(path)")

        guard let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            print("❌ Could not load contents of plist into dictionary")
            return
        }

        apiKey = dict["TMDB_API_KEY"] as? String ?? ""
        baseURL = dict["TMDB_BASE_URL"] as? String ?? ""
        print("✅ Loaded Secrets: API_KEY = \(apiKey), BASE_URL = \(baseURL)")
    }

   
}

