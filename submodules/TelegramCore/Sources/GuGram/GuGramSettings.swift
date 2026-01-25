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

    private let editedMessagesKey = "GuGram_EditedMessages"
    private let editedMessagesPromise = ValuePromise<Bool>(false)
    
    private let deletedMessagesKey = "gg_showDeletedMessages"
    private let deletedMessagesPromise = ValuePromise<Bool>(false)

    private let bypassCopyProtectionKey = "GuGram_BypassCopyProtection"
    private let bypassCopyProtectionPromise = ValuePromise<Bool>(false)
    
    public var ghostModeSignal: Signal<Bool, NoError> {
        return self.ghostModePromise.get()
    }
    
    public var localPremiumSignal: Signal<Bool, NoError> {
        return self.localPremiumPromise.get()
    }
    
    public var hideStoriesSignal: Signal<Bool, NoError> {
        return self.hideStoriesPromise.get()
    }

    public var editedMessagesSignal: Signal<Bool, NoError> {
        return self.editedMessagesPromise.get()
    }
    
    public var deletedMessagesSignal: Signal<Bool, NoError> {
        return self.deletedMessagesPromise.get()
    }

    public var bypassCopyProtectionSignal: Signal<Bool, NoError> {
        return self.bypassCopyProtectionPromise.get()
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

    public var isEditedMessagesEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: editedMessagesKey) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: editedMessagesKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: editedMessagesKey)
            self.editedMessagesPromise.set(newValue)
        }
    }
    
    public var isDeletedMessagesEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: deletedMessagesKey) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: deletedMessagesKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: deletedMessagesKey)
            self.deletedMessagesPromise.set(newValue)
        }
    }

    public var isBypassCopyProtectionEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: bypassCopyProtectionKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: bypassCopyProtectionKey)
            self.bypassCopyProtectionPromise.set(newValue)
        }
    }
    
    init() {
        self.ghostModePromise.set(self.isGhostModeEnabled)
        self.localPremiumPromise.set(self.isLocalPremiumEnabled)
        self.hideStoriesPromise.set(self.isHideStoriesEnabled)
        self.editedMessagesPromise.set(self.isEditedMessagesEnabled)
        self.deletedMessagesPromise.set(self.isDeletedMessagesEnabled)
        self.bypassCopyProtectionPromise.set(self.isBypassCopyProtectionEnabled)
    }
}
