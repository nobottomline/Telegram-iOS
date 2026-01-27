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
        // Custom Gift State
        public var isCustomGiftEnabled: Bool
        public var activeCustomGift: GuGramCustomGift
        public var visualEffects: VisualEffects
        public var profileBackground: ProfileBackground
        public var isProfileBackgroundEnabled: Bool
        public var showGiftsOnProfile: Bool
        public var customGiftCount: Int32
        public var giftAnimationStyle: Int32
        public var selectedGiftPreset: String
        public var customGiftInnerColor: Int32
        public var customGiftOuterColor: Int32
        public var customGiftPatternColor: Int32
        public var customGiftTextColor: Int32
        public var customGiftRibbon: String
        public var customGiftGlowEnabled: Bool
        public var customGiftParticlesEnabled: Bool
        public var profileBackgroundPrimaryColor: Int32
        public var profileBackgroundSecondaryColor: Int32
        public var profileBackgroundPatternColor: Int32
        public var profileBackgroundAnimated: Bool
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

        let s2a = combineLatest(queue: .mainQueue(),
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
            self.customRatingInfoNextLevelInfinityPromise.get()
        )

        let s2b = combineLatest(queue: .mainQueue(),
            self.hideGuGramSettingsEntryPromise.get(),
            self.customNamePromise.get(),
            self.isCustomNameEnabledPromise.get(),
            self.customPhoneNumberPromise.get(),
            self.isCustomPhoneNumberEnabledPromise.get(),
            self.isCustomAvatarEnabledPromise.get(),
            self.isCustomGiftEnabledPromise.get(),
            self.activeCustomGiftPromise.get(),
            self.visualEffectsPromise.get(),
            self.profileBackgroundPromise.get(),
            self.isProfileBackgroundEnabledPromise.get(),
            self.showGiftsOnProfilePromise.get(),
            self.customGiftCountPromise.get(),
            self.giftAnimationStylePromise.get()
        )

        let s2c = combineLatest(queue: .mainQueue(),
            self.selectedGiftPresetPromise.get(),
            self.customGiftInnerColorPromise.get(),
            self.customGiftOuterColorPromise.get(),
            self.customGiftPatternColorPromise.get(),
            self.customGiftTextColorPromise.get(),
            self.customGiftRibbonPromise.get(),
            self.customGiftGlowEnabledPromise.get(),
            self.customGiftParticlesEnabledPromise.get(),
            self.profileBackgroundPrimaryColorPromise.get(),
            self.profileBackgroundSecondaryColorPromise.get(),
            self.profileBackgroundPatternColorPromise.get(),
            self.profileBackgroundAnimatedPromise.get()
        )

        return combineLatest(s1, s2a, s2b, s2c)
        |> map { v1, v2a, v2b, v2c in
            return State(
                ghostMode: v1.0,
                localPremium: v1.1,
                hideStories: v1.2,
                editedMessages: v1.3,
                deletedMessages: v1.4,
                bypassCopyProtection: v1.5,
                hidePhoneNumber: v1.6,
                hideUsername: v1.7,
                hideName: v2a.0,
                hideAvatar: v2a.1,
                customUsername: v2a.2,
                isCustomUsernameEnabled: v2a.3,
                hideRatingBadge: v2a.4,
                isCustomRatingBadgeEnabled: v2a.5,
                customRatingBadgeLevel: v2a.6,
                customRatingBadgeColor: v2a.7,
                customRatingBadgeInfinity: v2a.8,
                customRatingBadgeShapeStyle: v2a.9,
                customRatingBadgeShapeLevel: v2a.10,
                isCustomRatingInfoEnabled: v2a.11,
                customRatingInfoCurrentStars: v2a.12,
                customRatingInfoNextStars: v2a.13,
                customRatingInfoCurrentStarsInfinity: v2a.14,
                customRatingInfoNextStarsInfinity: v2a.15,
                customRatingInfoCurrentLevel: v2a.16,
                customRatingInfoNextLevel: v2a.17,
                customRatingInfoCurrentLevelInfinity: v2a.18,
                customRatingInfoNextLevelInfinity: v2a.19,
                hideGuGramSettingsEntry: v2b.0,
                customName: v2b.1,
                isCustomNameEnabled: v2b.2,
                customPhoneNumber: v2b.3,
                isCustomPhoneNumberEnabled: v2b.4,
                isCustomAvatarEnabled: v2b.5,
                customAvatarPath: v1.8,
                isCustomGiftEnabled: v2b.6,
                activeCustomGift: v2b.7,
                visualEffects: v2b.8,
                profileBackground: v2b.9,
                isProfileBackgroundEnabled: v2b.10,
                showGiftsOnProfile: v2b.11,
                customGiftCount: v2b.12,
                giftAnimationStyle: v2b.13,
                selectedGiftPreset: v2c.0,
                customGiftInnerColor: v2c.1,
                customGiftOuterColor: v2c.2,
                customGiftPatternColor: v2c.3,
                customGiftTextColor: v2c.4,
                customGiftRibbon: v2c.5,
                customGiftGlowEnabled: v2c.6,
                customGiftParticlesEnabled: v2c.7,
                profileBackgroundPrimaryColor: v2c.8,
                profileBackgroundSecondaryColor: v2c.9,
                profileBackgroundPatternColor: v2c.10,
                profileBackgroundAnimated: v2c.11
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

    // MARK: - Custom Gift Settings

    /// Represents a custom visual gift with full customization options
    public struct GuGramCustomGift: Codable, Equatable {
        public let id: Int64
        public let name: String
        public let modelId: String           // Gift model identifier (e.g., "party_penguin", "star_cake")
        public let patternId: String         // Pattern identifier (e.g., "shape_star", "shape_heart")
        public let innerColor: Int32         // Inner/center gradient color
        public let outerColor: Int32         // Outer/edge gradient color
        public let patternColor: Int32       // Pattern overlay color
        public let textColor: Int32          // Text/label color
        public let ribbonText: String?       // Optional ribbon text (e.g., "#1", "VIP")
        public let ribbonColor: Int32        // Ribbon background color
        public let glowEnabled: Bool         // Enable glow effect
        public let glowColor: Int32          // Glow color
        public let particlesEnabled: Bool    // Enable particle effects
        public let particleColor: Int32      // Particle color
        public let rarity: Int32             // Visual rarity level (affects animations)

        public init(
            id: Int64,
            name: String,
            modelId: String,
            patternId: String,
            innerColor: Int32,
            outerColor: Int32,
            patternColor: Int32,
            textColor: Int32,
            ribbonText: String? = nil,
            ribbonColor: Int32 = 0xFF5C55,
            glowEnabled: Bool = true,
            glowColor: Int32 = 0xFFFFFF,
            particlesEnabled: Bool = true,
            particleColor: Int32 = 0xFFFFFF,
            rarity: Int32 = 1000
        ) {
            self.id = id
            self.name = name
            self.modelId = modelId
            self.patternId = patternId
            self.innerColor = innerColor
            self.outerColor = outerColor
            self.patternColor = patternColor
            self.textColor = textColor
            self.ribbonText = ribbonText
            self.ribbonColor = ribbonColor
            self.glowEnabled = glowEnabled
            self.glowColor = glowColor
            self.particlesEnabled = particlesEnabled
            self.particleColor = particleColor
            self.rarity = rarity
        }

        public static let defaultGift = GuGramCustomGift(
            id: 1,
            name: "GuGram Premium",
            modelId: "party_penguin",
            patternId: "shape_star",
            innerColor: 0x6B5CFF,
            outerColor: 0x3B2DB3,
            patternColor: 0xFFFFFF,
            textColor: 0xFFFFFF,
            ribbonText: "∞",
            ribbonColor: 0xFFAB00,
            glowEnabled: true,
            glowColor: 0x6B5CFF,
            particlesEnabled: true,
            particleColor: 0xFFD700,
            rarity: 10000
        )

        /// Predefined gift themes
        public static let presets: [GuGramCustomGift] = [
            // Golden Crown - Prestigious gold theme
            GuGramCustomGift(
                id: 100,
                name: "Golden Crown",
                modelId: "golden_crown",
                patternId: "shape_crown",
                innerColor: 0xFFD700,
                outerColor: 0xB8860B,
                patternColor: 0xFFF8DC,
                textColor: 0xFFFFFF,
                ribbonText: "👑",
                ribbonColor: 0xFFD700,
                glowEnabled: true,
                glowColor: 0xFFD700,
                particlesEnabled: true,
                particleColor: 0xFFD700,
                rarity: 10000
            ),
            // Neon Cyber - Futuristic cyan/pink
            GuGramCustomGift(
                id: 101,
                name: "Neon Cyber",
                modelId: "cyber_orb",
                patternId: "shape_circuit",
                innerColor: 0x00FFFF,
                outerColor: 0xFF00FF,
                patternColor: 0x00FF00,
                textColor: 0x00FFFF,
                ribbonText: "NFT",
                ribbonColor: 0xFF00FF,
                glowEnabled: true,
                glowColor: 0x00FFFF,
                particlesEnabled: true,
                particleColor: 0xFF00FF,
                rarity: 5000
            ),
            // Royal Purple - Elegant purple theme
            GuGramCustomGift(
                id: 102,
                name: "Royal Purple",
                modelId: "royal_gem",
                patternId: "shape_diamond",
                innerColor: 0x9B59B6,
                outerColor: 0x6C3483,
                patternColor: 0xE8DAEF,
                textColor: 0xFFFFFF,
                ribbonText: "VIP",
                ribbonColor: 0x9B59B6,
                glowEnabled: true,
                glowColor: 0x9B59B6,
                particlesEnabled: true,
                particleColor: 0xE8DAEF,
                rarity: 7500
            ),
            // Ocean Blue - Deep sea theme
            GuGramCustomGift(
                id: 103,
                name: "Ocean Blue",
                modelId: "sea_shell",
                patternId: "shape_wave",
                innerColor: 0x3498DB,
                outerColor: 0x1A5276,
                patternColor: 0xAED6F1,
                textColor: 0xFFFFFF,
                ribbonText: nil,
                ribbonColor: 0x3498DB,
                glowEnabled: true,
                glowColor: 0x3498DB,
                particlesEnabled: true,
                particleColor: 0xAED6F1,
                rarity: 3000
            ),
            // Fire Phoenix - Hot orange/red theme
            GuGramCustomGift(
                id: 104,
                name: "Fire Phoenix",
                modelId: "phoenix_flame",
                patternId: "shape_flame",
                innerColor: 0xFF4500,
                outerColor: 0x8B0000,
                patternColor: 0xFFD700,
                textColor: 0xFFFFFF,
                ribbonText: "🔥",
                ribbonColor: 0xFF4500,
                glowEnabled: true,
                glowColor: 0xFF4500,
                particlesEnabled: true,
                particleColor: 0xFFD700,
                rarity: 8000
            ),
            // Emerald Forest - Nature green theme
            GuGramCustomGift(
                id: 105,
                name: "Emerald Forest",
                modelId: "forest_spirit",
                patternId: "shape_leaf",
                innerColor: 0x2ECC71,
                outerColor: 0x1E8449,
                patternColor: 0xABEBC6,
                textColor: 0xFFFFFF,
                ribbonText: nil,
                ribbonColor: 0x2ECC71,
                glowEnabled: true,
                glowColor: 0x2ECC71,
                particlesEnabled: true,
                particleColor: 0xABEBC6,
                rarity: 2500
            ),
            // Midnight Galaxy - Space theme
            GuGramCustomGift(
                id: 106,
                name: "Midnight Galaxy",
                modelId: "galaxy_star",
                patternId: "shape_star",
                innerColor: 0x1C1C3C,
                outerColor: 0x0D0D1A,
                patternColor: 0xE6E6FA,
                textColor: 0xE6E6FA,
                ribbonText: "⭐",
                ribbonColor: 0x4B0082,
                glowEnabled: true,
                glowColor: 0x4B0082,
                particlesEnabled: true,
                particleColor: 0xFFFFFF,
                rarity: 9000
            ),
            // Rose Gold - Elegant pink/gold theme
            GuGramCustomGift(
                id: 107,
                name: "Rose Gold",
                modelId: "rose_heart",
                patternId: "shape_heart",
                innerColor: 0xF8B4B4,
                outerColor: 0xB76E79,
                patternColor: 0xFFE4E1,
                textColor: 0x8B4513,
                ribbonText: "💕",
                ribbonColor: 0xB76E79,
                glowEnabled: true,
                glowColor: 0xF8B4B4,
                particlesEnabled: true,
                particleColor: 0xFFD700,
                rarity: 6000
            )
        ]
    }

    /// Visual effect settings for profile and gifts
    public struct VisualEffects: Codable, Equatable {
        public var glowIntensity: Float      // 0.0 - 1.0
        public var particleDensity: Float    // 0.0 - 1.0
        public var animationSpeed: Float     // 0.5 - 2.0
        public var hoverAmplitude: Float     // Hover animation amplitude
        public var wiggleEnabled: Bool       // Enable wiggle animation
        public var pulseEnabled: Bool        // Enable pulse/breathing effect

        public init(
            glowIntensity: Float = 0.65,
            particleDensity: Float = 0.8,
            animationSpeed: Float = 1.0,
            hoverAmplitude: Float = 1.0,
            wiggleEnabled: Bool = true,
            pulseEnabled: Bool = true
        ) {
            self.glowIntensity = glowIntensity
            self.particleDensity = particleDensity
            self.animationSpeed = animationSpeed
            self.hoverAmplitude = hoverAmplitude
            self.wiggleEnabled = wiggleEnabled
            self.pulseEnabled = pulseEnabled
        }

        public static let `default` = VisualEffects()
    }

    /// Profile background customization
    public struct ProfileBackground: Codable, Equatable {
        public var primaryColor: Int32       // Main gradient color
        public var secondaryColor: Int32     // Secondary gradient color
        public var patternColor: Int32       // Pattern overlay color
        public var patternId: String?        // Pattern identifier
        public var patternOpacity: Float     // Pattern opacity 0.0 - 1.0
        public var gradientAngle: Float      // Gradient angle in degrees
        public var animatedGradient: Bool    // Enable animated gradient

        public init(
            primaryColor: Int32 = 0x6B5CFF,
            secondaryColor: Int32 = 0x3B2DB3,
            patternColor: Int32 = 0xFFFFFF,
            patternId: String? = nil,
            patternOpacity: Float = 0.3,
            gradientAngle: Float = 180.0,
            animatedGradient: Bool = false
        ) {
            self.primaryColor = primaryColor
            self.secondaryColor = secondaryColor
            self.patternColor = patternColor
            self.patternId = patternId
            self.patternOpacity = patternOpacity
            self.gradientAngle = gradientAngle
            self.animatedGradient = animatedGradient
        }

        public static let `default` = ProfileBackground()

        public static let presets: [String: ProfileBackground] = [
            "royal_purple": ProfileBackground(
                primaryColor: 0x9B59B6,
                secondaryColor: 0x6C3483,
                patternColor: 0xE8DAEF,
                patternOpacity: 0.25
            ),
            "ocean_blue": ProfileBackground(
                primaryColor: 0x3498DB,
                secondaryColor: 0x1A5276,
                patternColor: 0xAED6F1,
                patternOpacity: 0.3
            ),
            "sunset_orange": ProfileBackground(
                primaryColor: 0xE74C3C,
                secondaryColor: 0xF39C12,
                patternColor: 0xFAD7A0,
                patternOpacity: 0.35
            ),
            "midnight": ProfileBackground(
                primaryColor: 0x2C3E50,
                secondaryColor: 0x1A252F,
                patternColor: 0x5D6D7E,
                patternOpacity: 0.2
            ),
            "neon_cyber": ProfileBackground(
                primaryColor: 0x00FFFF,
                secondaryColor: 0xFF00FF,
                patternColor: 0x00FF00,
                patternOpacity: 0.4,
                animatedGradient: true
            )
        ]
    }

    // Custom Gift Keys
    private let isCustomGiftEnabledKey = "GuGram_IsCustomGiftEnabled"
    private let isCustomGiftEnabledPromise = ValuePromise<Bool>(false)

    private let activeCustomGiftKey = "GuGram_ActiveCustomGift"
    private let activeCustomGiftPromise = ValuePromise<GuGramCustomGift>(GuGramCustomGift.defaultGift)

    private let customGiftsKey = "GuGram_CustomGifts"
    private let customGiftsPromise = ValuePromise<[GuGramCustomGift]>([])

    private let visualEffectsKey = "GuGram_VisualEffects"
    private let visualEffectsPromise = ValuePromise<VisualEffects>(VisualEffects.default)

    private let profileBackgroundKey = "GuGram_ProfileBackground"
    private let profileBackgroundPromise = ValuePromise<ProfileBackground>(ProfileBackground.default)

    private let isProfileBackgroundEnabledKey = "GuGram_IsProfileBackgroundEnabled"
    private let isProfileBackgroundEnabledPromise = ValuePromise<Bool>(false)

    private let showGiftsOnProfileKey = "GuGram_ShowGiftsOnProfile"
    private let showGiftsOnProfilePromise = ValuePromise<Bool>(true)

    private let customGiftCountKey = "GuGram_CustomGiftCount"
    private let customGiftCountPromise = ValuePromise<Int32>(6)

    private let giftAnimationStyleKey = "GuGram_GiftAnimationStyle"
    private let giftAnimationStylePromise = ValuePromise<Int32>(0)

    private let selectedGiftPresetKey = "GuGram_SelectedGiftPreset"
    private let selectedGiftPresetPromise = ValuePromise<String>("none")

    private let customGiftInnerColorKey = "GuGram_CustomGiftInnerColor"
    private let customGiftInnerColorPromise = ValuePromise<Int32>(0x6B5CFF)

    private let customGiftOuterColorKey = "GuGram_CustomGiftOuterColor"
    private let customGiftOuterColorPromise = ValuePromise<Int32>(0x3B2DB3)

    private let customGiftPatternColorKey = "GuGram_CustomGiftPatternColor"
    private let customGiftPatternColorPromise = ValuePromise<Int32>(0xFFFFFF)

    private let customGiftTextColorKey = "GuGram_CustomGiftTextColor"
    private let customGiftTextColorPromise = ValuePromise<Int32>(0xFFFFFF)

    private let customGiftRibbonKey = "GuGram_CustomGiftRibbon"
    private let customGiftRibbonPromise = ValuePromise<String>("")

    private let customGiftGlowEnabledKey = "GuGram_CustomGiftGlowEnabled"
    private let customGiftGlowEnabledPromise = ValuePromise<Bool>(true)

    private let customGiftParticlesEnabledKey = "GuGram_CustomGiftParticlesEnabled"
    private let customGiftParticlesEnabledPromise = ValuePromise<Bool>(true)

    private let profileBackgroundPrimaryColorKey = "GuGram_ProfileBackgroundPrimaryColor"
    private let profileBackgroundPrimaryColorPromise = ValuePromise<Int32>(0x1A1A2E)

    private let profileBackgroundSecondaryColorKey = "GuGram_ProfileBackgroundSecondaryColor"
    private let profileBackgroundSecondaryColorPromise = ValuePromise<Int32>(0x16213E)

    private let profileBackgroundPatternColorKey = "GuGram_ProfileBackgroundPatternColor"
    private let profileBackgroundPatternColorPromise = ValuePromise<Int32>(0x0F3460)

    private let profileBackgroundAnimatedKey = "GuGram_ProfileBackgroundAnimated"
    private let profileBackgroundAnimatedPromise = ValuePromise<Bool>(false)

    // Signals
    public var isCustomGiftEnabledSignal: Signal<Bool, NoError> {
        return self.isCustomGiftEnabledPromise.get()
    }

    public var activeCustomGiftSignal: Signal<GuGramCustomGift, NoError> {
        return self.activeCustomGiftPromise.get()
    }

    public var customGiftsSignal: Signal<[GuGramCustomGift], NoError> {
        return self.customGiftsPromise.get()
    }

    public var visualEffectsSignal: Signal<VisualEffects, NoError> {
        return self.visualEffectsPromise.get()
    }

    public var profileBackgroundSignal: Signal<ProfileBackground, NoError> {
        return self.profileBackgroundPromise.get()
    }

    public var isProfileBackgroundEnabledSignal: Signal<Bool, NoError> {
        return self.isProfileBackgroundEnabledPromise.get()
    }

    public var showGiftsOnProfileSignal: Signal<Bool, NoError> {
        return self.showGiftsOnProfilePromise.get()
    }

    public var customGiftCountSignal: Signal<Int32, NoError> {
        return self.customGiftCountPromise.get()
    }

    public var giftAnimationStyleSignal: Signal<Int32, NoError> {
        return self.giftAnimationStylePromise.get()
    }

    public var selectedGiftPresetSignal: Signal<String, NoError> {
        return self.selectedGiftPresetPromise.get()
    }

    public var customGiftInnerColorSignal: Signal<Int32, NoError> {
        return self.customGiftInnerColorPromise.get()
    }

    public var customGiftOuterColorSignal: Signal<Int32, NoError> {
        return self.customGiftOuterColorPromise.get()
    }

    public var customGiftPatternColorSignal: Signal<Int32, NoError> {
        return self.customGiftPatternColorPromise.get()
    }

    public var customGiftTextColorSignal: Signal<Int32, NoError> {
        return self.customGiftTextColorPromise.get()
    }

    public var customGiftRibbonSignal: Signal<String, NoError> {
        return self.customGiftRibbonPromise.get()
    }

    public var customGiftGlowEnabledSignal: Signal<Bool, NoError> {
        return self.customGiftGlowEnabledPromise.get()
    }

    public var customGiftParticlesEnabledSignal: Signal<Bool, NoError> {
        return self.customGiftParticlesEnabledPromise.get()
    }

    public var profileBackgroundPrimaryColorSignal: Signal<Int32, NoError> {
        return self.profileBackgroundPrimaryColorPromise.get()
    }

    public var profileBackgroundSecondaryColorSignal: Signal<Int32, NoError> {
        return self.profileBackgroundSecondaryColorPromise.get()
    }

    public var profileBackgroundPatternColorSignal: Signal<Int32, NoError> {
        return self.profileBackgroundPatternColorPromise.get()
    }

    public var profileBackgroundAnimatedSignal: Signal<Bool, NoError> {
        return self.profileBackgroundAnimatedPromise.get()
    }

    // Properties
    public var isCustomGiftEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isCustomGiftEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isCustomGiftEnabledKey)
            self.isCustomGiftEnabledPromise.set(newValue)
        }
    }

    public var activeCustomGift: GuGramCustomGift {
        get {
            if let data = UserDefaults.standard.data(forKey: activeCustomGiftKey),
               let gift = try? JSONDecoder().decode(GuGramCustomGift.self, from: data) {
                return gift
            }
            return GuGramCustomGift.defaultGift
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: activeCustomGiftKey)
                self.activeCustomGiftPromise.set(newValue)
            }
        }
    }

    public var customGifts: [GuGramCustomGift] {
        get {
            if let data = UserDefaults.standard.data(forKey: customGiftsKey),
               let gifts = try? JSONDecoder().decode([GuGramCustomGift].self, from: data) {
                return gifts
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: customGiftsKey)
                self.customGiftsPromise.set(newValue)
            }
        }
    }

    public var visualEffects: VisualEffects {
        get {
            if let data = UserDefaults.standard.data(forKey: visualEffectsKey),
               let effects = try? JSONDecoder().decode(VisualEffects.self, from: data) {
                return effects
            }
            return VisualEffects.default
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: visualEffectsKey)
                self.visualEffectsPromise.set(newValue)
            }
        }
    }

    public var profileBackground: ProfileBackground {
        get {
            if let data = UserDefaults.standard.data(forKey: profileBackgroundKey),
               let background = try? JSONDecoder().decode(ProfileBackground.self, from: data) {
                return background
            }
            return ProfileBackground.default
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: profileBackgroundKey)
                self.profileBackgroundPromise.set(newValue)
            }
        }
    }

    public var isProfileBackgroundEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isProfileBackgroundEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isProfileBackgroundEnabledKey)
            self.isProfileBackgroundEnabledPromise.set(newValue)
        }
    }

    public var showGiftsOnProfile: Bool {
        get {
            if UserDefaults.standard.object(forKey: showGiftsOnProfileKey) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: showGiftsOnProfileKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: showGiftsOnProfileKey)
            self.showGiftsOnProfilePromise.set(newValue)
        }
    }

    public var customGiftCount: Int32 {
        get {
            let value = UserDefaults.standard.integer(forKey: customGiftCountKey)
            return value == 0 ? 6 : Int32(value)
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: customGiftCountKey)
            self.customGiftCountPromise.set(newValue)
        }
    }

    /// Gift animation style: 0 = none, 1 = floating, 2 = orbit, 3 = pulse, 4 = bounce
    public var giftAnimationStyle: Int32 {
        get {
            return Int32(UserDefaults.standard.integer(forKey: giftAnimationStyleKey))
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: giftAnimationStyleKey)
            self.giftAnimationStylePromise.set(newValue)
        }
    }

    private static let giftPresetKeyToId: [String: Int64] = [
        "goldenCrown": 100,
        "neonCyber": 101,
        "royalPurple": 102,
        "oceanBlue": 103,
        "firePhoenix": 104,
        "emeraldForest": 105,
        "midnightGalaxy": 106,
        "roseGold": 107
    ]

    private func resolvedActiveCustomGift() -> GuGramCustomGift {
        if self.selectedGiftPreset == "custom" {
            let base = GuGramCustomGift.defaultGift
            let ribbonText = self.customGiftRibbon.trimmingCharacters(in: .whitespacesAndNewlines)
            let resolvedRibbonText = ribbonText.isEmpty ? nil : ribbonText
            return GuGramCustomGift(
                id: base.id,
                name: "Custom Gift",
                modelId: base.modelId,
                patternId: base.patternId,
                innerColor: self.customGiftInnerColor,
                outerColor: self.customGiftOuterColor,
                patternColor: self.customGiftPatternColor,
                textColor: self.customGiftTextColor,
                ribbonText: resolvedRibbonText,
                ribbonColor: self.customGiftOuterColor,
                glowEnabled: self.customGiftGlowEnabled,
                glowColor: self.customGiftInnerColor,
                particlesEnabled: self.customGiftParticlesEnabled,
                particleColor: self.customGiftPatternColor,
                rarity: base.rarity
            )
        }

        if let presetId = GuGramSettings.giftPresetKeyToId[self.selectedGiftPreset],
           let preset = GuGramCustomGift.presets.first(where: { $0.id == presetId }) {
            return preset
        }

        return GuGramCustomGift.defaultGift
    }

    private func updateActiveCustomGiftFromSettings() {
        let resolved = self.resolvedActiveCustomGift()
        if self.activeCustomGift != resolved {
            self.activeCustomGift = resolved
        }
    }

    public var selectedGiftPreset: String {
        get {
            return UserDefaults.standard.string(forKey: selectedGiftPresetKey) ?? "none"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: selectedGiftPresetKey)
            self.selectedGiftPresetPromise.set(newValue)
            self.updateActiveCustomGiftFromSettings()
        }
    }

    public var customGiftInnerColor: Int32 {
        get {
            let value = UserDefaults.standard.integer(forKey: customGiftInnerColorKey)
            return value == 0 ? 0x6B5CFF : Int32(value)
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: customGiftInnerColorKey)
            self.customGiftInnerColorPromise.set(newValue)
            self.updateActiveCustomGiftFromSettings()
        }
    }

    public var customGiftOuterColor: Int32 {
        get {
            let value = UserDefaults.standard.integer(forKey: customGiftOuterColorKey)
            return value == 0 ? 0x3B2DB3 : Int32(value)
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: customGiftOuterColorKey)
            self.customGiftOuterColorPromise.set(newValue)
            self.updateActiveCustomGiftFromSettings()
        }
    }

    public var customGiftPatternColor: Int32 {
        get {
            let value = UserDefaults.standard.integer(forKey: customGiftPatternColorKey)
            return value == 0 ? 0xFFFFFF : Int32(value)
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: customGiftPatternColorKey)
            self.customGiftPatternColorPromise.set(newValue)
            self.updateActiveCustomGiftFromSettings()
        }
    }

    public var customGiftTextColor: Int32 {
        get {
            let value = UserDefaults.standard.integer(forKey: customGiftTextColorKey)
            return value == 0 ? 0xFFFFFF : Int32(value)
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: customGiftTextColorKey)
            self.customGiftTextColorPromise.set(newValue)
            self.updateActiveCustomGiftFromSettings()
        }
    }

    public var customGiftRibbon: String {
        get {
            return UserDefaults.standard.string(forKey: customGiftRibbonKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customGiftRibbonKey)
            self.customGiftRibbonPromise.set(newValue)
            self.updateActiveCustomGiftFromSettings()
        }
    }

    public var customGiftGlowEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: customGiftGlowEnabledKey) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: customGiftGlowEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customGiftGlowEnabledKey)
            self.customGiftGlowEnabledPromise.set(newValue)
            self.updateActiveCustomGiftFromSettings()
        }
    }

    public var customGiftParticlesEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: customGiftParticlesEnabledKey) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: customGiftParticlesEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customGiftParticlesEnabledKey)
            self.customGiftParticlesEnabledPromise.set(newValue)
            self.updateActiveCustomGiftFromSettings()
        }
    }

    public var profileBackgroundPrimaryColor: Int32 {
        get {
            let value = UserDefaults.standard.integer(forKey: profileBackgroundPrimaryColorKey)
            return value == 0 ? 0x1A1A2E : Int32(value)
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: profileBackgroundPrimaryColorKey)
            self.profileBackgroundPrimaryColorPromise.set(newValue)
        }
    }

    public var profileBackgroundSecondaryColor: Int32 {
        get {
            let value = UserDefaults.standard.integer(forKey: profileBackgroundSecondaryColorKey)
            return value == 0 ? 0x16213E : Int32(value)
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: profileBackgroundSecondaryColorKey)
            self.profileBackgroundSecondaryColorPromise.set(newValue)
        }
    }

    public var profileBackgroundPatternColor: Int32 {
        get {
            let value = UserDefaults.standard.integer(forKey: profileBackgroundPatternColorKey)
            return value == 0 ? 0x0F3460 : Int32(value)
        }
        set {
            UserDefaults.standard.set(Int(newValue), forKey: profileBackgroundPatternColorKey)
            self.profileBackgroundPatternColorPromise.set(newValue)
        }
    }

    public var profileBackgroundAnimated: Bool {
        get {
            return UserDefaults.standard.bool(forKey: profileBackgroundAnimatedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: profileBackgroundAnimatedKey)
            self.profileBackgroundAnimatedPromise.set(newValue)
        }
    }

    // Helper methods
    public func addCustomGift(_ gift: GuGramCustomGift) {
        var gifts = self.customGifts
        gifts.append(gift)
        self.customGifts = gifts
    }

    public func removeCustomGift(id: Int64) {
        var gifts = self.customGifts
        gifts.removeAll { $0.id == id }
        self.customGifts = gifts
    }

    public func updateCustomGift(_ gift: GuGramCustomGift) {
        var gifts = self.customGifts
        if let index = gifts.firstIndex(where: { $0.id == gift.id }) {
            gifts[index] = gift
            self.customGifts = gifts
        }
    }

    public func getGiftPreset(id: Int64) -> GuGramCustomGift? {
        return GuGramCustomGift.presets.first { $0.id == id }
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
        // Initialize custom gift settings
        self.isCustomGiftEnabledPromise.set(self.isCustomGiftEnabled)
        self.activeCustomGiftPromise.set(self.activeCustomGift)
        self.customGiftsPromise.set(self.customGifts)
        self.visualEffectsPromise.set(self.visualEffects)
        self.profileBackgroundPromise.set(self.profileBackground)
        self.isProfileBackgroundEnabledPromise.set(self.isProfileBackgroundEnabled)
        self.showGiftsOnProfilePromise.set(self.showGiftsOnProfile)
        self.customGiftCountPromise.set(self.customGiftCount)
        self.giftAnimationStylePromise.set(self.giftAnimationStyle)
        // Initialize individual gift customization
        self.selectedGiftPresetPromise.set(self.selectedGiftPreset)
        self.customGiftInnerColorPromise.set(self.customGiftInnerColor)
        self.customGiftOuterColorPromise.set(self.customGiftOuterColor)
        self.customGiftPatternColorPromise.set(self.customGiftPatternColor)
        self.customGiftTextColorPromise.set(self.customGiftTextColor)
        self.customGiftRibbonPromise.set(self.customGiftRibbon)
        self.customGiftGlowEnabledPromise.set(self.customGiftGlowEnabled)
        self.customGiftParticlesEnabledPromise.set(self.customGiftParticlesEnabled)
        // Initialize profile background customization
        self.profileBackgroundPrimaryColorPromise.set(self.profileBackgroundPrimaryColor)
        self.profileBackgroundSecondaryColorPromise.set(self.profileBackgroundSecondaryColor)
        self.profileBackgroundPatternColorPromise.set(self.profileBackgroundPatternColor)
        self.profileBackgroundAnimatedPromise.set(self.profileBackgroundAnimated)
        self.updateActiveCustomGiftFromSettings()
    }
}

// MARK: - Gift Model Identifiers
extension GuGramSettings {
    /// Available gift model identifiers (corresponds to Telegram's gift animations)
    public static let availableGiftModels: [(id: String, name: String, description: String)] = [
        ("party_penguin", "Party Penguin", "Cute penguin with party hat"),
        ("golden_crown", "Golden Crown", "Royal golden crown"),
        ("star_cake", "Star Cake", "Birthday cake with star"),
        ("cyber_orb", "Cyber Orb", "Futuristic glowing orb"),
        ("royal_gem", "Royal Gem", "Precious gemstone"),
        ("sea_shell", "Sea Shell", "Ocean seashell"),
        ("phoenix_flame", "Phoenix Flame", "Mythical fire bird"),
        ("forest_spirit", "Forest Spirit", "Nature spirit"),
        ("galaxy_star", "Galaxy Star", "Cosmic star"),
        ("rose_heart", "Rose Heart", "Romantic rose"),
        ("diamond", "Diamond", "Brilliant diamond"),
        ("rocket", "Rocket", "Space rocket"),
        ("rainbow_unicorn", "Rainbow Unicorn", "Magical unicorn"),
        ("lucky_clover", "Lucky Clover", "Four-leaf clover"),
        ("crystal_ball", "Crystal Ball", "Mystical crystal ball")
    ]

    /// Available pattern identifiers
    public static let availablePatterns: [(id: String, name: String)] = [
        ("shape_star", "Stars"),
        ("shape_heart", "Hearts"),
        ("shape_diamond", "Diamonds"),
        ("shape_crown", "Crowns"),
        ("shape_flame", "Flames"),
        ("shape_leaf", "Leaves"),
        ("shape_wave", "Waves"),
        ("shape_circuit", "Circuit"),
        ("shape_sparkle", "Sparkles"),
        ("shape_moon", "Moons"),
        ("shape_flower", "Flowers"),
        ("shape_snowflake", "Snowflakes")
    ]

    /// Predefined color palettes for gifts
    public static let colorPalettes: [(name: String, inner: Int32, outer: Int32, pattern: Int32, text: Int32)] = [
        ("Royal Purple", 0x9B59B6, 0x6C3483, 0xE8DAEF, 0xFFFFFF),
        ("Ocean Blue", 0x3498DB, 0x1A5276, 0xAED6F1, 0xFFFFFF),
        ("Emerald Green", 0x2ECC71, 0x1E8449, 0xABEBC6, 0xFFFFFF),
        ("Sunset Orange", 0xE74C3C, 0xB03A2E, 0xFAD7A0, 0xFFFFFF),
        ("Golden", 0xFFD700, 0xB8860B, 0xFFF8DC, 0x000000),
        ("Neon Pink", 0xFF00FF, 0xC71585, 0xFFB6C1, 0xFFFFFF),
        ("Cyber Teal", 0x00FFFF, 0x008B8B, 0xE0FFFF, 0x000000),
        ("Midnight", 0x2C3E50, 0x1A252F, 0x5D6D7E, 0xFFFFFF),
        ("Rose Gold", 0xF8B4B4, 0xB76E79, 0xFFE4E1, 0x8B4513),
        ("Silver", 0xC0C0C0, 0x808080, 0xE8E8E8, 0x000000)
    ]

    /// Animation style descriptions
    public static let animationStyles: [(id: Int32, name: String, description: String)] = [
        (0, "None", "No animation"),
        (1, "Floating", "Gifts float gently"),
        (2, "Orbit", "Gifts move in small circular paths"),
        (3, "Pulse", "Gifts pulse softly"),
        (4, "Bounce", "Gifts bounce vertically")
    ]
}
