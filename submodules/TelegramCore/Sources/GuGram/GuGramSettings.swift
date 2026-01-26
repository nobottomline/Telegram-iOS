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

    private let isCustomRatingBadgeEnabledKey = "GuGram_IsCustomRatingBadgeEnabled"
    private let isCustomRatingBadgeEnabledPromise = ValuePromise<Bool>(false)

    private let customRatingBadgeLevelKey = "GuGram_CustomRatingBadgeLevel"
    private let customRatingBadgeLevelPromise = ValuePromise<Int32>(1)

    private let customRatingBadgeColorKey = "GuGram_CustomRatingBadgeColor"
    private let customRatingBadgeColorPromise = ValuePromise<Int32>(0)

    private let customRatingBadgeInfinityKey = "GuGram_CustomRatingBadgeInfinity"
    private let customRatingBadgeInfinityPromise = ValuePromise<Bool>(false)

    private let customRatingBadgeShapeStyleKey = "GuGram_CustomRatingBadgeShapeStyle"
    private let customRatingBadgeShapeStylePromise = ValuePromise<Int32>(0)

    private let customRatingBadgeShapeLevelKey = "GuGram_CustomRatingBadgeShapeLevel"
    private let customRatingBadgeShapeLevelPromise = ValuePromise<Int32>(10)

    private let isCustomRatingInfoEnabledKey = "GuGram_IsCustomRatingInfoEnabled"
    private let isCustomRatingInfoEnabledPromise = ValuePromise<Bool>(false)

    private let customRatingInfoCurrentStarsKey = "GuGram_CustomRatingInfoCurrentStars"
    private let customRatingInfoCurrentStarsPromise = ValuePromise<Int64>(0)

    private let customRatingInfoNextStarsKey = "GuGram_CustomRatingInfoNextStars"
    private let customRatingInfoNextStarsPromise = ValuePromise<Int64>(-1)

    private let customRatingInfoCurrentStarsInfinityKey = "GuGram_CustomRatingInfoCurrentStarsInfinity"
    private let customRatingInfoCurrentStarsInfinityPromise = ValuePromise<Bool>(false)

    private let customRatingInfoNextStarsInfinityKey = "GuGram_CustomRatingInfoNextStarsInfinity"
    private let customRatingInfoNextStarsInfinityPromise = ValuePromise<Bool>(false)

    private let customRatingInfoCurrentLevelKey = "GuGram_CustomRatingInfoCurrentLevel"
    private let customRatingInfoCurrentLevelPromise = ValuePromise<Int32>(1)

    private let customRatingInfoNextLevelKey = "GuGram_CustomRatingInfoNextLevel"
    private let customRatingInfoNextLevelPromise = ValuePromise<Int32>(0)

    private let customRatingInfoCurrentLevelInfinityKey = "GuGram_CustomRatingInfoCurrentLevelInfinity"
    private let customRatingInfoCurrentLevelInfinityPromise = ValuePromise<Bool>(false)

    private let customRatingInfoNextLevelInfinityKey = "GuGram_CustomRatingInfoNextLevelInfinity"
    private let customRatingInfoNextLevelInfinityPromise = ValuePromise<Bool>(false)

    private let hideGuGramSettingsEntryKey = "GuGram_HideSettingsEntry"
    private let hideGuGramSettingsEntryPromise = ValuePromise<Bool>(false)

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

    public var isCustomRatingBadgeEnabledSignal: Signal<Bool, NoError> {
        return self.isCustomRatingBadgeEnabledPromise.get()
    }

    public var customRatingBadgeLevelSignal: Signal<Int32, NoError> {
        return self.customRatingBadgeLevelPromise.get()
    }

    public var customRatingBadgeColorSignal: Signal<Int32, NoError> {
        return self.customRatingBadgeColorPromise.get()
    }

    public var customRatingBadgeInfinitySignal: Signal<Bool, NoError> {
        return self.customRatingBadgeInfinityPromise.get()
    }

    public var customRatingBadgeShapeStyleSignal: Signal<Int32, NoError> {
        return self.customRatingBadgeShapeStylePromise.get()
    }

    public var customRatingBadgeShapeLevelSignal: Signal<Int32, NoError> {
        return self.customRatingBadgeShapeLevelPromise.get()
    }

    public var isCustomRatingInfoEnabledSignal: Signal<Bool, NoError> {
        return self.isCustomRatingInfoEnabledPromise.get()
    }

    public var customRatingInfoCurrentStarsSignal: Signal<Int64, NoError> {
        return self.customRatingInfoCurrentStarsPromise.get()
    }

    public var customRatingInfoNextStarsSignal: Signal<Int64, NoError> {
        return self.customRatingInfoNextStarsPromise.get()
    }

    public var customRatingInfoCurrentStarsInfinitySignal: Signal<Bool, NoError> {
        return self.customRatingInfoCurrentStarsInfinityPromise.get()
    }

    public var customRatingInfoNextStarsInfinitySignal: Signal<Bool, NoError> {
        return self.customRatingInfoNextStarsInfinityPromise.get()
    }

    public var customRatingInfoCurrentLevelSignal: Signal<Int32, NoError> {
        return self.customRatingInfoCurrentLevelPromise.get()
    }

    public var customRatingInfoNextLevelSignal: Signal<Int32, NoError> {
        return self.customRatingInfoNextLevelPromise.get()
    }

    public var customRatingInfoCurrentLevelInfinitySignal: Signal<Bool, NoError> {
        return self.customRatingInfoCurrentLevelInfinityPromise.get()
    }

    public var customRatingInfoNextLevelInfinitySignal: Signal<Bool, NoError> {
        return self.customRatingInfoNextLevelInfinityPromise.get()
    }

    public var hideGuGramSettingsEntrySignal: Signal<Bool, NoError> {
        return self.hideGuGramSettingsEntryPromise.get()
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
        public var isCustomRatingBadgeEnabled: Bool
        public var customRatingBadgeLevel: Int32
        public var customRatingBadgeColor: Int32
        public var customRatingBadgeInfinity: Bool
        public var customRatingBadgeShapeStyle: Int32
        public var customRatingBadgeShapeLevel: Int32
        public var isCustomRatingInfoEnabled: Bool
        public var customRatingInfoCurrentStars: Int64
        public var customRatingInfoNextStars: Int64
        public var customRatingInfoCurrentStarsInfinity: Bool
        public var customRatingInfoNextStarsInfinity: Bool
        public var customRatingInfoCurrentLevel: Int32
        public var customRatingInfoNextLevel: Int32
        public var customRatingInfoCurrentLevelInfinity: Bool
        public var customRatingInfoNextLevelInfinity: Bool
        public var hideGuGramSettingsEntry: Bool
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
            self.hideUsernamePromise.get(),
            self.customAvatarPathPromise.get()
        )
        let s2 = combineLatest(queue: .mainQueue(),
            self.hideNamePromise.get(),
            self.hideAvatarPromise.get(),
            self.customUsernamePromise.get(),
            self.isCustomUsernameEnabledPromise.get(),
            self.hideRatingBadgePromise.get(),
            self.isCustomRatingBadgeEnabledPromise.get(),
            self.customRatingBadgeLevelPromise.get(),
            self.customRatingBadgeColorPromise.get(),
            self.customRatingBadgeInfinityPromise.get(),
            self.customRatingBadgeShapeStylePromise.get(),
            self.customRatingBadgeShapeLevelPromise.get(),
            self.isCustomRatingInfoEnabledPromise.get(),
            self.customRatingInfoCurrentStarsPromise.get(),
            self.customRatingInfoNextStarsPromise.get(),
            self.customRatingInfoCurrentStarsInfinityPromise.get(),
            self.customRatingInfoNextStarsInfinityPromise.get(),
            self.customRatingInfoCurrentLevelPromise.get(),
            self.customRatingInfoNextLevelPromise.get(),
            self.customRatingInfoCurrentLevelInfinityPromise.get(),
            self.customRatingInfoNextLevelInfinityPromise.get(),
            self.hideGuGramSettingsEntryPromise.get(),
            self.customNamePromise.get(),
            self.isCustomNameEnabledPromise.get(),
            self.customPhoneNumberPromise.get(),
            self.isCustomPhoneNumberEnabledPromise.get(),
            self.isCustomAvatarEnabledPromise.get()
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
                isCustomRatingBadgeEnabled: v2.5,
                customRatingBadgeLevel: v2.6,
                customRatingBadgeColor: v2.7,
                customRatingBadgeInfinity: v2.8,
                customRatingBadgeShapeStyle: v2.9,
                customRatingBadgeShapeLevel: v2.10,
                isCustomRatingInfoEnabled: v2.11,
                customRatingInfoCurrentStars: v2.12,
                customRatingInfoNextStars: v2.13,
                customRatingInfoCurrentStarsInfinity: v2.14,
                customRatingInfoNextStarsInfinity: v2.15,
                customRatingInfoCurrentLevel: v2.16,
                customRatingInfoNextLevel: v2.17,
                customRatingInfoCurrentLevelInfinity: v2.18,
                customRatingInfoNextLevelInfinity: v2.19,
                hideGuGramSettingsEntry: v2.20,
                customName: v2.21,
                isCustomNameEnabled: v2.22,
                customPhoneNumber: v2.23,
                isCustomPhoneNumberEnabled: v2.24,
                isCustomAvatarEnabled: v2.25,
                customAvatarPath: v1.8
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

    public var isCustomRatingBadgeEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isCustomRatingBadgeEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isCustomRatingBadgeEnabledKey)
            self.isCustomRatingBadgeEnabledPromise.set(newValue)
        }
    }

    public var customRatingBadgeLevel: Int32 {
        get {
            let value = UserDefaults.standard.integer(forKey: customRatingBadgeLevelKey)
            return value == 0 ? 1 : Int32(value)
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: customRatingBadgeLevelKey)
            self.customRatingBadgeLevelPromise.set(newValue)
        }
    }

    public var customRatingBadgeColor: Int32 {
        get {
            return Int32(UserDefaults.standard.integer(forKey: customRatingBadgeColorKey))
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: customRatingBadgeColorKey)
            self.customRatingBadgeColorPromise.set(newValue)
        }
    }

    public var customRatingBadgeInfinity: Bool {
        get {
            return UserDefaults.standard.bool(forKey: customRatingBadgeInfinityKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customRatingBadgeInfinityKey)
            self.customRatingBadgeInfinityPromise.set(newValue)
        }
    }

    public var customRatingBadgeShapeStyle: Int32 {
        get {
            return Int32(UserDefaults.standard.integer(forKey: customRatingBadgeShapeStyleKey))
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: customRatingBadgeShapeStyleKey)
            self.customRatingBadgeShapeStylePromise.set(newValue)
        }
    }

    public var customRatingBadgeShapeLevel: Int32 {
        get {
            let value = UserDefaults.standard.integer(forKey: customRatingBadgeShapeLevelKey)
            return value == 0 ? 10 : Int32(value)
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: customRatingBadgeShapeLevelKey)
            self.customRatingBadgeShapeLevelPromise.set(newValue)
        }
    }

    public var isCustomRatingInfoEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isCustomRatingInfoEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isCustomRatingInfoEnabledKey)
            self.isCustomRatingInfoEnabledPromise.set(newValue)
        }
    }

    public var customRatingInfoCurrentStars: Int64 {
        get {
            return Int64(UserDefaults.standard.integer(forKey: customRatingInfoCurrentStarsKey))
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customRatingInfoCurrentStarsKey)
            self.customRatingInfoCurrentStarsPromise.set(newValue)
        }
    }

    public var customRatingInfoNextStars: Int64 {
        get {
            if UserDefaults.standard.object(forKey: customRatingInfoNextStarsKey) == nil {
                return -1
            }
            return Int64(UserDefaults.standard.integer(forKey: customRatingInfoNextStarsKey))
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customRatingInfoNextStarsKey)
            self.customRatingInfoNextStarsPromise.set(newValue)
        }
    }

    public var customRatingInfoCurrentStarsInfinity: Bool {
        get {
            return UserDefaults.standard.bool(forKey: customRatingInfoCurrentStarsInfinityKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customRatingInfoCurrentStarsInfinityKey)
            self.customRatingInfoCurrentStarsInfinityPromise.set(newValue)
        }
    }

    public var customRatingInfoNextStarsInfinity: Bool {
        get {
            return UserDefaults.standard.bool(forKey: customRatingInfoNextStarsInfinityKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customRatingInfoNextStarsInfinityKey)
            self.customRatingInfoNextStarsInfinityPromise.set(newValue)
        }
    }

    public var customRatingInfoCurrentLevel: Int32 {
        get {
            let value = UserDefaults.standard.integer(forKey: customRatingInfoCurrentLevelKey)
            return value == 0 ? 1 : Int32(value)
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: customRatingInfoCurrentLevelKey)
            self.customRatingInfoCurrentLevelPromise.set(newValue)
        }
    }

    public var customRatingInfoNextLevel: Int32 {
        get {
            return Int32(UserDefaults.standard.integer(forKey: customRatingInfoNextLevelKey))
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: customRatingInfoNextLevelKey)
            self.customRatingInfoNextLevelPromise.set(newValue)
        }
    }

    public var customRatingInfoCurrentLevelInfinity: Bool {
        get {
            return UserDefaults.standard.bool(forKey: customRatingInfoCurrentLevelInfinityKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customRatingInfoCurrentLevelInfinityKey)
            self.customRatingInfoCurrentLevelInfinityPromise.set(newValue)
        }
    }

    public var customRatingInfoNextLevelInfinity: Bool {
        get {
            return UserDefaults.standard.bool(forKey: customRatingInfoNextLevelInfinityKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customRatingInfoNextLevelInfinityKey)
            self.customRatingInfoNextLevelInfinityPromise.set(newValue)
        }
    }

    public var hideGuGramSettingsEntry: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hideGuGramSettingsEntryKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hideGuGramSettingsEntryKey)
            self.hideGuGramSettingsEntryPromise.set(newValue)
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
        self.isCustomRatingBadgeEnabledPromise.set(self.isCustomRatingBadgeEnabled)
        self.customRatingBadgeLevelPromise.set(self.customRatingBadgeLevel)
        self.customRatingBadgeColorPromise.set(self.customRatingBadgeColor)
        self.customRatingBadgeInfinityPromise.set(self.customRatingBadgeInfinity)
        self.customRatingBadgeShapeStylePromise.set(self.customRatingBadgeShapeStyle)
        self.customRatingBadgeShapeLevelPromise.set(self.customRatingBadgeShapeLevel)
        self.isCustomRatingInfoEnabledPromise.set(self.isCustomRatingInfoEnabled)
        self.customRatingInfoCurrentStarsPromise.set(self.customRatingInfoCurrentStars)
        self.customRatingInfoNextStarsPromise.set(self.customRatingInfoNextStars)
        self.customRatingInfoCurrentStarsInfinityPromise.set(self.customRatingInfoCurrentStarsInfinity)
        self.customRatingInfoNextStarsInfinityPromise.set(self.customRatingInfoNextStarsInfinity)
        self.customRatingInfoCurrentLevelPromise.set(self.customRatingInfoCurrentLevel)
        self.customRatingInfoNextLevelPromise.set(self.customRatingInfoNextLevel)
        self.customRatingInfoCurrentLevelInfinityPromise.set(self.customRatingInfoCurrentLevelInfinity)
        self.customRatingInfoNextLevelInfinityPromise.set(self.customRatingInfoNextLevelInfinity)
        UserDefaults.standard.set(false, forKey: hideGuGramSettingsEntryKey)
        self.hideGuGramSettingsEntryPromise.set(false)
        self.customNamePromise.set(self.customName)
        self.isCustomNameEnabledPromise.set(self.isCustomNameEnabled)
        self.customPhoneNumberPromise.set(self.customPhoneNumber)
        self.isCustomPhoneNumberEnabledPromise.set(self.isCustomPhoneNumberEnabled)
        self.isCustomAvatarEnabledPromise.set(self.isCustomAvatarEnabled)
        self.customAvatarPathPromise.set(self.customAvatarPath)
    }
}
