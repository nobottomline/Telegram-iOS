import Foundation
import SwiftSignalKit

public final class GuGramSettings {
    public static let shared = GuGramSettings()
    
    private let ghostModeKey = "GuGram_GhostMode"
    private let ghostModePromise = ValuePromise<Bool>(false)
    
    private let localPremiumKey = "GuGram_LocalPremium"
    private let localPremiumPromise = ValuePromise<Bool>(false)
    
    private let hideStoriesKey = "GuGram_HideStories"
    private let hideStoriesPromise = ValuePromise<Bool>(false)
    
    public var ghostModeSignal: Signal<Bool, NoError> {
        return self.ghostModePromise.get()
    }
    
    public var localPremiumSignal: Signal<Bool, NoError> {
        return self.localPremiumPromise.get()
    }
    
    public var hideStoriesSignal: Signal<Bool, NoError> {
        return self.hideStoriesPromise.get()
    }
    
    public var isGhostModeEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: ghostModeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ghostModeKey)
            self.ghostModePromise.set(newValue)
        }
    }
    
    public var isLocalPremiumEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: localPremiumKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: localPremiumKey)
            self.localPremiumPromise.set(newValue)
        }
    }
    
    public var isHideStoriesEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hideStoriesKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hideStoriesKey)
            self.hideStoriesPromise.set(newValue)
        }
    }
    
    init() {
        self.ghostModePromise.set(self.isGhostModeEnabled)
        self.localPremiumPromise.set(self.isLocalPremiumEnabled)
        self.hideStoriesPromise.set(self.isHideStoriesEnabled)
    }
}
