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

    private let hidePhoneNumberKey = "GuGram_HidePhoneNumber"
    private let hidePhoneNumberPromise = ValuePromise<Bool>(false)

    private let hideUsernameKey = "GuGram_HideUsername"
    private let hideUsernamePromise = ValuePromise<Bool>(false)

    private let hideNameKey = "GuGram_HideName"
    private let hideNamePromise = ValuePromise<Bool>(false)

    private let hideAvatarKey = "GuGram_HideAvatar"
    private let hideAvatarPromise = ValuePromise<Bool>(false)

    private let customUsernameKey = "GuGram_CustomUsername"
    private let customUsernamePromise = ValuePromise<String>("")

    private let isCustomUsernameEnabledKey = "GuGram_IsCustomUsernameEnabled"
    private let isCustomUsernameEnabledPromise = ValuePromise<Bool>(false)

    private let hideRatingBadgeKey = "GuGram_HideRatingBadge"
    private let hideRatingBadgePromise = ValuePromise<Bool>(false)

    private let customNameKey = "GuGram_CustomName"
    private let customNamePromise = ValuePromise<String>("")

    private let isCustomNameEnabledKey = "GuGram_IsCustomNameEnabled"
    private let isCustomNameEnabledPromise = ValuePromise<Bool>(false)

    private let customPhoneNumberKey = "GuGram_CustomPhoneNumber"
    private let customPhoneNumberPromise = ValuePromise<String>("")

    private let isCustomPhoneNumberEnabledKey = "GuGram_IsCustomPhoneNumberEnabled"
    private let isCustomPhoneNumberEnabledPromise = ValuePromise<Bool>(false)

    private let isCustomAvatarEnabledKey = "GuGram_IsCustomAvatarEnabled"
    private let isCustomAvatarEnabledPromise = ValuePromise<Bool>(false)

    private let customAvatarPathKey = "GuGram_CustomAvatarPath"
    private let customAvatarPathPromise = ValuePromise<String?>(nil)

    private let customAvatarVersionKey = "GuGram_CustomAvatarVersion"

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

    public var hidePhoneNumberSignal: Signal<Bool, NoError> {
        return self.hidePhoneNumberPromise.get()
    }

    public var hideUsernameSignal: Signal<Bool, NoError> {
        return self.hideUsernamePromise.get()
    }

    public var hideNameSignal: Signal<Bool, NoError> {
        return self.hideNamePromise.get()
    }

    public var hideAvatarSignal: Signal<Bool, NoError> {
        return self.hideAvatarPromise.get()
    }

    public var customUsernameSignal: Signal<String, NoError> {
        return self.customUsernamePromise.get()
    }

    public var isCustomUsernameEnabledSignal: Signal<Bool, NoError> {
        return self.isCustomUsernameEnabledPromise.get()
    }

    public var hideRatingBadgeSignal: Signal<Bool, NoError> {
        return self.hideRatingBadgePromise.get()
    }

    public var customNameSignal: Signal<String, NoError> {
        return self.customNamePromise.get()
    }

    public var isCustomNameEnabledSignal: Signal<Bool, NoError> {
        return self.isCustomNameEnabledPromise.get()
    }

    public var customPhoneNumberSignal: Signal<String, NoError> {
        return self.customPhoneNumberPromise.get()
    }

    public var isCustomPhoneNumberEnabledSignal: Signal<Bool, NoError> {
        return self.isCustomPhoneNumberEnabledPromise.get()
    }

    public var isCustomAvatarEnabledSignal: Signal<Bool, NoError> {
        return self.isCustomAvatarEnabledPromise.get()
    }

    public var customAvatarPathSignal: Signal<String?, NoError> {
        return self.customAvatarPathPromise.get()
    }

    public struct State: Equatable {
        public var ghostMode: Bool
        public var localPremium: Bool
        public var hideStories: Bool
        public var editedMessages: Bool
        public var deletedMessages: Bool
        public var bypassCopyProtection: Bool
        public var hidePhoneNumber: Bool
        public var hideUsername: Bool
        public var hideName: Bool
        public var hideAvatar: Bool
        public var customUsername: String
        public var isCustomUsernameEnabled: Bool
        public var hideRatingBadge: Bool
        public var customName: String
        public var isCustomNameEnabled: Bool
        public var customPhoneNumber: String
        public var isCustomPhoneNumberEnabled: Bool
        public var isCustomAvatarEnabled: Bool
        public var customAvatarPath: String?
    }

    public var settingsStateSignal: Signal<State, NoError> {
        let s1 = combineLatest(
            self.ghostModePromise.get(),
            self.localPremiumPromise.get(),
            self.hideStoriesPromise.get(),
            self.editedMessagesPromise.get(),
            self.deletedMessagesPromise.get(),
            self.bypassCopyProtectionPromise.get(),
            self.hidePhoneNumberPromise.get(),
            self.hideUsernamePromise.get()
        )
        let s2 = combineLatest(
            self.hideNamePromise.get(),
            self.hideAvatarPromise.get(),
            self.customUsernamePromise.get(),
            self.isCustomUsernameEnabledPromise.get(),
            self.hideRatingBadgePromise.get(),
            self.customNamePromise.get(),
            self.isCustomNameEnabledPromise.get(),
            self.customPhoneNumberPromise.get(),
            self.isCustomPhoneNumberEnabledPromise.get(),
            self.isCustomAvatarEnabledPromise.get(),
            self.customAvatarPathPromise.get()
        )
        return combineLatest(s1, s2)
        |> map { v1, v2 in
            return State(
                ghostMode: v1.0,
                localPremium: v1.1,
                hideStories: v1.2,
                editedMessages: v1.3,
                deletedMessages: v1.4,
                bypassCopyProtection: v1.5,
                hidePhoneNumber: v1.6,
                hideUsername: v1.7,
                hideName: v2.0,
                hideAvatar: v2.1,
                customUsername: v2.2,
                isCustomUsernameEnabled: v2.3,
                hideRatingBadge: v2.4,
                customName: v2.5,
                isCustomNameEnabled: v2.6,
                customPhoneNumber: v2.7,
                isCustomPhoneNumberEnabled: v2.8,
                isCustomAvatarEnabled: v2.9,
                customAvatarPath: v2.10
            )
        }
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

    public var isHidePhoneNumberEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hidePhoneNumberKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hidePhoneNumberKey)
            self.hidePhoneNumberPromise.set(newValue)
        }
    }

    public var isHideUsernameEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hideUsernameKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hideUsernameKey)
            self.hideUsernamePromise.set(newValue)
        }
    }

    public var isHideNameEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hideNameKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hideNameKey)
            self.hideNamePromise.set(newValue)
        }
    }

    public var isHideAvatarEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hideAvatarKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hideAvatarKey)
            self.hideAvatarPromise.set(newValue)
        }
    }

    public var customUsername: String {
        get {
            return UserDefaults.standard.string(forKey: customUsernameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customUsernameKey)
            self.customUsernamePromise.set(newValue)
        }
    }

    public var isCustomUsernameEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isCustomUsernameEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isCustomUsernameEnabledKey)
            self.isCustomUsernameEnabledPromise.set(newValue)
        }
    }

    public var isHideRatingBadgeEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hideRatingBadgeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hideRatingBadgeKey)
            self.hideRatingBadgePromise.set(newValue)
        }
    }

    public var customName: String {
        get {
            return UserDefaults.standard.string(forKey: customNameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customNameKey)
            self.customNamePromise.set(newValue)
        }
    }

    public var isCustomNameEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isCustomNameEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isCustomNameEnabledKey)
            self.isCustomNameEnabledPromise.set(newValue)
        }
    }

    public var customPhoneNumber: String {
        get {
            return UserDefaults.standard.string(forKey: customPhoneNumberKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customPhoneNumberKey)
            self.customPhoneNumberPromise.set(newValue)
        }
    }

    public var isCustomPhoneNumberEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isCustomPhoneNumberEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isCustomPhoneNumberEnabledKey)
            self.isCustomPhoneNumberEnabledPromise.set(newValue)
        }
    }

    public var isCustomAvatarEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isCustomAvatarEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isCustomAvatarEnabledKey)
            self.isCustomAvatarEnabledPromise.set(newValue)
        }
    }

    public var customAvatarPath: String? {
        get {
            return UserDefaults.standard.string(forKey: customAvatarPathKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customAvatarPathKey)
            self.customAvatarPathPromise.set(newValue)
            // Increment version to invalidate cache
            let currentVersion = UserDefaults.standard.integer(forKey: customAvatarVersionKey)
            UserDefaults.standard.set(currentVersion + 1, forKey: customAvatarVersionKey)
        }
    }

    public var customAvatarVersion: Int64 {
        return Int64(UserDefaults.standard.integer(forKey: customAvatarVersionKey))
    }

    init() {
        self.ghostModePromise.set(self.isGhostModeEnabled)
        self.localPremiumPromise.set(self.isLocalPremiumEnabled)
        self.hideStoriesPromise.set(self.isHideStoriesEnabled)
        self.editedMessagesPromise.set(self.isEditedMessagesEnabled)
        self.deletedMessagesPromise.set(self.isDeletedMessagesEnabled)
        self.bypassCopyProtectionPromise.set(self.isBypassCopyProtectionEnabled)
        self.hidePhoneNumberPromise.set(self.isHidePhoneNumberEnabled)
        self.hideUsernamePromise.set(self.isHideUsernameEnabled)
        self.hideNamePromise.set(self.isHideNameEnabled)
        self.hideAvatarPromise.set(self.isHideAvatarEnabled)
        self.customUsernamePromise.set(self.customUsername)
        self.isCustomUsernameEnabledPromise.set(self.isCustomUsernameEnabled)
        self.hideRatingBadgePromise.set(self.isHideRatingBadgeEnabled)
        self.customNamePromise.set(self.customName)
        self.isCustomNameEnabledPromise.set(self.isCustomNameEnabled)
        self.customPhoneNumberPromise.set(self.customPhoneNumber)
        self.isCustomPhoneNumberEnabledPromise.set(self.isCustomPhoneNumberEnabled)
        self.isCustomAvatarEnabledPromise.set(self.isCustomAvatarEnabled)
        self.customAvatarPathPromise.set(self.customAvatarPath)
    }
}
