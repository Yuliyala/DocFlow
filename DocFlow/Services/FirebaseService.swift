import Foundation
import FirebaseCore
import FirebaseRemoteConfig

class FirebaseService {
    private var remoteConfig: RemoteConfig?
    static let shared = FirebaseService()
    private var isConfigured = false

    private init() {
        setup()
    }

    var isGreyFlow: Bool {
        guard isConfigured else { return false }
        return remoteConfig?.configValue(forKey: Constants.firebaseFlagKey).boolValue ?? false
    }

    func setup() {
        guard FirebaseApp.app() != nil else {
            #if DEBUG
            print("⚠️ FirebaseService: Firebase not configured, skipping RemoteConfig setup")
            #endif
            isConfigured = false
            return
        }
        
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
        isConfigured = true
    }
    
    func load() async {
        guard isConfigured else {
            #if DEBUG
            print("⚠️ FirebaseService: Skipping load - Firebase not configured")
            #endif
            return
        }
        
        do {
            let status = try await remoteConfig?.fetch()
            try await remoteConfig?.activate()
            #if DEBUG
            print("✅ Firebase RemoteConfig loaded successfully")
            #endif
        } catch {
            #if DEBUG
            print("❌ Firebase RemoteConfig error: \(error)")
            #endif
        }
    }
}
