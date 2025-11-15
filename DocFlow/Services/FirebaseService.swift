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
        // Проверяем что Firebase настроен
        guard FirebaseApp.app() != nil else {
            print("⚠️ FirebaseService: Firebase not configured, skipping RemoteConfig setup")
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
            print("⚠️ FirebaseService: Skipping load - Firebase not configured")
            return
        }
        
        do {
            let status = try await remoteConfig?.fetch()
            try await remoteConfig?.activate()
            print("✅ Firebase RemoteConfig loaded successfully")
        } catch {
            print("❌ Firebase RemoteConfig error: \(error)")
        }
    }
}


