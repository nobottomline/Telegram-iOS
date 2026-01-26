import Foundation
import UIKit
import PhotosUI
import UniformTypeIdentifiers
import Display
import SwiftSignalKit
import Postbox
import TelegramCore
import TelegramPresentationData
import TelegramUIPreferences
import ItemListUI
import PresentationDataUtils
import AccountContext

private final class GuGramSettingsControllerArguments {
    let context: AccountContext
    let updateCustomUsername: (String) -> Void
    let selectCustomAvatar: () -> Void
    let selectRatingBadgeShape: () -> Void
    
    init(context: AccountContext, updateCustomUsername: @escaping (String) -> Void, selectCustomAvatar: @escaping () -> Void, selectRatingBadgeShape: @escaping () -> Void) {
        self.context = context
        self.updateCustomUsername = updateCustomUsername
        self.selectCustomAvatar = selectCustomAvatar
        self.selectRatingBadgeShape = selectRatingBadgeShape
    }
}

@available(iOS 14.0, *)
private final class ImagePickerDelegate: NSObject, PHPickerViewControllerDelegate {
    let completion: (UIImage?) -> Void
    
    init(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            self.completion(nil)
            return
        }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            self?.completion(image as? UIImage)
        }
    }
}

private final class LegacyImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let completion: (UIImage?) -> Void
    
    init(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[.originalImage] as? UIImage
        self.completion(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.completion(nil)
    }
}

private final class DocumentPickerDelegate: NSObject, UIDocumentPickerDelegate {
    let completion: (UIImage?) -> Void
    
    init(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            self.completion(nil)
            return
        }
        
        if url.startAccessingSecurityScopedResource() {
            defer { url.stopAccessingSecurityScopedResource() }
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                self.completion(image)
            } else {
                self.completion(nil)
            }
        } else {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                self.completion(image)
            } else {
                self.completion(nil)
            }
        }
    }
    
    func documentPickerDidCancel(_ controller: UIDocumentPickerViewController) {
        self.completion(nil)
    }
}

private var currentImagePickerDelegate: NSObject?

private enum GuGramSettingsSection: Int32 {
    case core
    case privacy
    case identity
    case ratingBadge
    case ratingInfo
    case about
}

private enum GuGramSettingsEntry: ItemListNodeEntry {
    case sectionHeader(PresentationTheme, String, GuGramSettingsSection)
    case ghostMode(PresentationTheme, String, Bool)
    case localPremium(PresentationTheme, String, Bool)
    case hideStories(PresentationTheme, String, Bool)
    case editedMessages(PresentationTheme, String, Bool)
    case deletedMessages(PresentationTheme, String, Bool)
    case bypassCopyProtection(PresentationTheme, String, Bool)
    case hidePhoneNumber(PresentationTheme, String, Bool)
    case hideUsername(PresentationTheme, String, Bool)
    case hideName(PresentationTheme, String, Bool)
    case hideAvatar(PresentationTheme, String, Bool)
    case customUsername(PresentationTheme, String, String)
    case isCustomUsernameEnabled(PresentationTheme, String, Bool)
    case customName(PresentationTheme, String, String)
    case isCustomNameEnabled(PresentationTheme, String, Bool)
    case customPhoneNumber(PresentationTheme, String, String)
    case isCustomPhoneNumberEnabled(PresentationTheme, String, Bool)
    case isCustomAvatarEnabled(PresentationTheme, String, Bool)
    case selectCustomAvatar(PresentationTheme, String)
    case hideRatingBadge(PresentationTheme, String, Bool)
    case isCustomRatingBadgeEnabled(PresentationTheme, String, Bool)
    case customRatingBadgeLevel(PresentationTheme, String, Int32)
    case customRatingBadgeInfinity(PresentationTheme, String, Bool)
    case customRatingBadgeShape(PresentationTheme, String, Int32)
    case customRatingBadgeShapeLevel(PresentationTheme, String, Int32)
    case customRatingBadgeColor(PresentationTheme, String, Int32)
    case isCustomRatingInfoEnabled(PresentationTheme, String, Bool)
    case customRatingInfoCurrentStars(PresentationTheme, String, Int64)
    case customRatingInfoNextStars(PresentationTheme, String, Int64)
    case customRatingInfoCurrentStarsInfinity(PresentationTheme, String, Bool)
    case customRatingInfoNextStarsInfinity(PresentationTheme, String, Bool)
    case customRatingInfoCurrentLevel(PresentationTheme, String, Int32)
    case customRatingInfoNextLevel(PresentationTheme, String, Int32)
    case customRatingInfoCurrentLevelInfinity(PresentationTheme, String, Bool)
    case customRatingInfoNextLevelInfinity(PresentationTheme, String, Bool)
    case hideGuGramSettingsEntry(PresentationTheme, String, Bool)
    case info(PresentationTheme, String)
    
    var section: ItemListSectionId {
        switch self {
        case let .sectionHeader(_, _, section):
            return section.rawValue
        case .ghostMode, .localPremium, .hideStories, .editedMessages, .deletedMessages, .bypassCopyProtection:
            return GuGramSettingsSection.core.rawValue
        case .hidePhoneNumber, .hideUsername, .hideName, .hideAvatar:
            return GuGramSettingsSection.privacy.rawValue
        case .customUsername, .isCustomUsernameEnabled, .customName, .isCustomNameEnabled, .customPhoneNumber, .isCustomPhoneNumberEnabled, .isCustomAvatarEnabled, .selectCustomAvatar:
            return GuGramSettingsSection.identity.rawValue
        case .hideRatingBadge, .isCustomRatingBadgeEnabled, .customRatingBadgeLevel, .customRatingBadgeInfinity, .customRatingBadgeShape, .customRatingBadgeShapeLevel, .customRatingBadgeColor:
            return GuGramSettingsSection.ratingBadge.rawValue
        case .isCustomRatingInfoEnabled, .customRatingInfoCurrentStars, .customRatingInfoNextStars, .customRatingInfoCurrentStarsInfinity, .customRatingInfoNextStarsInfinity, .customRatingInfoCurrentLevel, .customRatingInfoNextLevel, .customRatingInfoCurrentLevelInfinity, .customRatingInfoNextLevelInfinity:
            return GuGramSettingsSection.ratingInfo.rawValue
        case .hideGuGramSettingsEntry, .info:
            return GuGramSettingsSection.about.rawValue
        }
    }
    
    var stableId: Int32 {
        switch self {
        case let .sectionHeader(_, _, section): return section.rawValue * 1000
        case .ghostMode: return 10
        case .localPremium: return 11
        case .hideStories: return 12
        case .editedMessages: return 13
        case .deletedMessages: return 14
        case .bypassCopyProtection: return 15
        case .hidePhoneNumber: return 1010
        case .hideUsername: return 1011
        case .hideName: return 1012
        case .hideAvatar: return 1013
        case .isCustomUsernameEnabled: return 2010
        case .customUsername: return 2011
        case .isCustomNameEnabled: return 2012
        case .customName: return 2013
        case .isCustomPhoneNumberEnabled: return 2014
        case .customPhoneNumber: return 2015
        case .isCustomAvatarEnabled: return 2016
        case .selectCustomAvatar: return 2017
        case .hideRatingBadge: return 3010
        case .isCustomRatingBadgeEnabled: return 3011
        case .customRatingBadgeInfinity: return 3012
        case .customRatingBadgeLevel: return 3013
        case .customRatingBadgeShape: return 3014
        case .customRatingBadgeShapeLevel: return 3015
        case .customRatingBadgeColor: return 3016
        case .isCustomRatingInfoEnabled: return 4010
        case .customRatingInfoCurrentStarsInfinity: return 4011
        case .customRatingInfoCurrentStars: return 4012
        case .customRatingInfoNextStarsInfinity: return 4013
        case .customRatingInfoNextStars: return 4014
        case .customRatingInfoCurrentLevelInfinity: return 4015
        case .customRatingInfoCurrentLevel: return 4016
        case .customRatingInfoNextLevelInfinity: return 4017
        case .customRatingInfoNextLevel: return 4018
        case .hideGuGramSettingsEntry: return 5010
        case .info: return 5011
        }
    }
    
    static func ==(lhs: GuGramSettingsEntry, rhs: GuGramSettingsEntry) -> Bool {
        switch lhs {
        case let .sectionHeader(lhsTheme, lhsText, lhsSection):
            if case let .sectionHeader(rhsTheme, rhsText, rhsSection) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsSection == rhsSection {
                return true
            }
            return false
        case let .ghostMode(lhsTheme, lhsText, lhsValue):
            if case let .ghostMode(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .localPremium(lhsTheme, lhsText, lhsValue):
            if case let .localPremium(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .hideStories(lhsTheme, lhsText, lhsValue):
            if case let .hideStories(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .editedMessages(lhsTheme, lhsText, lhsValue):
            if case let .editedMessages(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .deletedMessages(lhsTheme, lhsText, lhsValue):
            if case let .deletedMessages(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .bypassCopyProtection(lhsTheme, lhsText, lhsValue):
            if case let .bypassCopyProtection(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .hidePhoneNumber(lhsTheme, lhsText, lhsValue):
            if case let .hidePhoneNumber(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .hideUsername(lhsTheme, lhsText, lhsValue):
            if case let .hideUsername(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .hideName(lhsTheme, lhsText, lhsValue):
            if case let .hideName(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .hideAvatar(lhsTheme, lhsText, lhsValue):
            if case let .hideAvatar(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customUsername(lhsTheme, lhsText, lhsValue):
            if case let .customUsername(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .isCustomUsernameEnabled(lhsTheme, lhsText, lhsValue):
            if case let .isCustomUsernameEnabled(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customName(lhsTheme, lhsText, lhsValue):
            if case let .customName(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .isCustomNameEnabled(lhsTheme, lhsText, lhsValue):
            if case let .isCustomNameEnabled(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customPhoneNumber(lhsTheme, lhsText, lhsValue):
            if case let .customPhoneNumber(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .isCustomPhoneNumberEnabled(lhsTheme, lhsText, lhsValue):
            if case let .isCustomPhoneNumberEnabled(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .isCustomAvatarEnabled(lhsTheme, lhsText, lhsValue):
            if case let .isCustomAvatarEnabled(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .selectCustomAvatar(lhsTheme, lhsText):
            if case let .selectCustomAvatar(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText {
                return true
            }
            return false
        case let .hideRatingBadge(lhsTheme, lhsText, lhsValue):
            if case let .hideRatingBadge(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .isCustomRatingBadgeEnabled(lhsTheme, lhsText, lhsValue):
            if case let .isCustomRatingBadgeEnabled(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customRatingBadgeLevel(lhsTheme, lhsText, lhsValue):
            if case let .customRatingBadgeLevel(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customRatingBadgeInfinity(lhsTheme, lhsText, lhsValue):
            if case let .customRatingBadgeInfinity(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customRatingBadgeShape(lhsTheme, lhsText, lhsValue):
            if case let .customRatingBadgeShape(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customRatingBadgeShapeLevel(lhsTheme, lhsText, lhsValue):
            if case let .customRatingBadgeShapeLevel(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customRatingBadgeColor(lhsTheme, lhsText, lhsValue):
            if case let .customRatingBadgeColor(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .isCustomRatingInfoEnabled(lhsTheme, lhsText, lhsValue):
            if case let .isCustomRatingInfoEnabled(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customRatingInfoCurrentStars(lhsTheme, lhsText, lhsValue):
            if case let .customRatingInfoCurrentStars(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customRatingInfoNextStars(lhsTheme, lhsText, lhsValue):
            if case let .customRatingInfoNextStars(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customRatingInfoCurrentStarsInfinity(lhsTheme, lhsText, lhsValue):
            if case let .customRatingInfoCurrentStarsInfinity(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customRatingInfoNextStarsInfinity(lhsTheme, lhsText, lhsValue):
            if case let .customRatingInfoNextStarsInfinity(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customRatingInfoCurrentLevel(lhsTheme, lhsText, lhsValue):
            if case let .customRatingInfoCurrentLevel(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customRatingInfoNextLevel(lhsTheme, lhsText, lhsValue):
            if case let .customRatingInfoNextLevel(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customRatingInfoCurrentLevelInfinity(lhsTheme, lhsText, lhsValue):
            if case let .customRatingInfoCurrentLevelInfinity(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .customRatingInfoNextLevelInfinity(lhsTheme, lhsText, lhsValue):
            if case let .customRatingInfoNextLevelInfinity(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .hideGuGramSettingsEntry(lhsTheme, lhsText, lhsValue):
            if case let .hideGuGramSettingsEntry(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                return true
            }
            return false
        case let .info(lhsTheme, lhsText):
            if case let .info(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText {
                return true
            }
            return false
        }
    }
    
    static func <(lhs: GuGramSettingsEntry, rhs: GuGramSettingsEntry) -> Bool {
        return lhs.stableId < rhs.stableId
    }
    
    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        switch self {
        case let .sectionHeader(_, text, _):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .ghostMode(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isGhostModeEnabled = value
            })
        case let .localPremium(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isLocalPremiumEnabled = value
            })
        case let .hideStories(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isHideStoriesEnabled = value
            })
        case let .editedMessages(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isEditedMessagesEnabled = value
            })
        case let .deletedMessages(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isDeletedMessagesEnabled = value
            })
        case let .bypassCopyProtection(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isBypassCopyProtectionEnabled = value
            })
        case let .hidePhoneNumber(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isHidePhoneNumberEnabled = value
            })
        case let .hideUsername(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isHideUsernameEnabled = value
            })
        case let .hideName(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isHideNameEnabled = value
            })
        case let .hideAvatar(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isHideAvatarEnabled = value
            })
        case let .customUsername(_, text, value):
            return ItemListSingleLineInputItem(presentationData: presentationData, title: NSAttributedString(string: text, font: Font.regular(presentationData.fontSize.itemListBaseFontSize), textColor: presentationData.theme.list.itemPrimaryTextColor), text: value, placeholder: "Custom Username", type: .username, sectionId: self.section, textUpdated: { text in
                GuGramSettings.shared.customUsername = text
            }, action: {
            })
        case let .isCustomUsernameEnabled(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isCustomUsernameEnabled = value
            })
        case let .customName(_, text, value):
            return ItemListSingleLineInputItem(presentationData: presentationData, title: NSAttributedString(string: text, font: Font.regular(presentationData.fontSize.itemListBaseFontSize), textColor: presentationData.theme.list.itemPrimaryTextColor), text: value, placeholder: "Custom Name", type: .regular(capitalization: true, autocorrection: true), sectionId: self.section, textUpdated: { text in
                GuGramSettings.shared.customName = text
            }, action: {
            })
        case let .isCustomNameEnabled(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isCustomNameEnabled = value
            })
        case let .customPhoneNumber(_, text, value):
            return ItemListSingleLineInputItem(presentationData: presentationData, title: NSAttributedString(string: text, font: Font.regular(presentationData.fontSize.itemListBaseFontSize), textColor: presentationData.theme.list.itemPrimaryTextColor), text: value, placeholder: "Custom Phone Number", type: .regular(capitalization: false, autocorrection: false), sectionId: self.section, textUpdated: { text in
                GuGramSettings.shared.customPhoneNumber = text
            }, action: {
            })
        case let .isCustomPhoneNumberEnabled(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isCustomPhoneNumberEnabled = value
            })
        case let .isCustomAvatarEnabled(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isCustomAvatarEnabled = value
            })
        case let .selectCustomAvatar(_, text):
            return ItemListActionItem(presentationData: presentationData, title: text, kind: .generic, alignment: .natural, sectionId: self.section, style: .blocks, action: {
                let arguments = arguments as! GuGramSettingsControllerArguments
                arguments.selectCustomAvatar()
            })
        case let .hideRatingBadge(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isHideRatingBadgeEnabled = value
            })
        case let .isCustomRatingBadgeEnabled(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isCustomRatingBadgeEnabled = value
            })
        case let .customRatingBadgeLevel(_, text, value):
            return ItemListSingleLineInputItem(presentationData: presentationData, title: NSAttributedString(string: text, font: Font.regular(presentationData.fontSize.itemListBaseFontSize), textColor: presentationData.theme.list.itemPrimaryTextColor), text: "\(value)", placeholder: "1, 99, 999, etc.", type: .number, sectionId: self.section, textUpdated: { text in
                if let intValue = Int32(text), intValue >= 1, intValue <= 999 {
                    GuGramSettings.shared.customRatingBadgeLevel = intValue
                }
            }, action: {
            })
        case let .customRatingBadgeInfinity(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.customRatingBadgeInfinity = value
            })
        case let .customRatingBadgeShape(_, text, value):
            let arguments = arguments as! GuGramSettingsControllerArguments
            return ItemListDisclosureItem(presentationData: presentationData, title: text, label: ratingBadgeShapeTitle(value), sectionId: self.section, style: .blocks, action: {
                arguments.selectRatingBadgeShape()
            })
        case let .customRatingBadgeShapeLevel(_, text, value):
            return ItemListSingleLineInputItem(presentationData: presentationData, title: NSAttributedString(string: text, font: Font.regular(presentationData.fontSize.itemListBaseFontSize), textColor: presentationData.theme.list.itemPrimaryTextColor), text: "\(value)", placeholder: "1-90 (shape)", type: .number, sectionId: self.section, textUpdated: { text in
                if let intValue = Int32(text), intValue >= 1 {
                    GuGramSettings.shared.customRatingBadgeShapeLevel = intValue
                }
            }, action: {
            })
        case let .customRatingBadgeColor(_, text, value):
            let hexString = value != 0 ? String(format: "%06X", value) : ""
            return ItemListSingleLineInputItem(presentationData: presentationData, title: NSAttributedString(string: text, font: Font.regular(presentationData.fontSize.itemListBaseFontSize), textColor: presentationData.theme.list.itemPrimaryTextColor), text: hexString, placeholder: "FF5500 (hex color)", type: .regular(capitalization: true, autocorrection: false), sectionId: self.section, textUpdated: { text in
                let cleanHex = text.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
                if cleanHex.isEmpty {
                    GuGramSettings.shared.customRatingBadgeColor = 0
                } else if let intValue = Int32(cleanHex, radix: 16) {
                    GuGramSettings.shared.customRatingBadgeColor = intValue
                }
            }, action: {
            })
        case let .isCustomRatingInfoEnabled(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.isCustomRatingInfoEnabled = value
            })
        case let .customRatingInfoCurrentStars(_, text, value):
            return ItemListSingleLineInputItem(presentationData: presentationData, title: NSAttributedString(string: text, font: Font.regular(presentationData.fontSize.itemListBaseFontSize), textColor: presentationData.theme.list.itemPrimaryTextColor), text: "\(value)", placeholder: "0, 1200, 999999", type: .number, sectionId: self.section, textUpdated: { text in
                if let intValue = Int64(text), intValue >= 0 {
                    GuGramSettings.shared.customRatingInfoCurrentStars = intValue
                }
            }, action: {
            })
        case let .customRatingInfoNextStars(_, text, value):
            let nextStarsText = value < 0 ? "" : "\(value)"
            return ItemListSingleLineInputItem(presentationData: presentationData, title: NSAttributedString(string: text, font: Font.regular(presentationData.fontSize.itemListBaseFontSize), textColor: presentationData.theme.list.itemPrimaryTextColor), text: nextStarsText, placeholder: "leave empty for max", type: .number, sectionId: self.section, textUpdated: { text in
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    GuGramSettings.shared.customRatingInfoNextStars = -1
                } else if let intValue = Int64(text), intValue >= 0 {
                    GuGramSettings.shared.customRatingInfoNextStars = intValue
                }
            }, action: {
            })
        case let .customRatingInfoCurrentStarsInfinity(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.customRatingInfoCurrentStarsInfinity = value
            })
        case let .customRatingInfoNextStarsInfinity(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.customRatingInfoNextStarsInfinity = value
            })
        case let .customRatingInfoCurrentLevel(_, text, value):
            return ItemListSingleLineInputItem(presentationData: presentationData, title: NSAttributedString(string: text, font: Font.regular(presentationData.fontSize.itemListBaseFontSize), textColor: presentationData.theme.list.itemPrimaryTextColor), text: "\(value)", placeholder: "1, 99, 9999", type: .number, sectionId: self.section, textUpdated: { text in
                if let intValue = Int32(text), intValue >= 1 {
                    GuGramSettings.shared.customRatingInfoCurrentLevel = intValue
                }
            }, action: {
            })
        case let .customRatingInfoNextLevel(_, text, value):
            let nextLevelText = value <= 0 ? "" : "\(value)"
            return ItemListSingleLineInputItem(presentationData: presentationData, title: NSAttributedString(string: text, font: Font.regular(presentationData.fontSize.itemListBaseFontSize), textColor: presentationData.theme.list.itemPrimaryTextColor), text: nextLevelText, placeholder: "auto (+1)", type: .number, sectionId: self.section, textUpdated: { text in
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    GuGramSettings.shared.customRatingInfoNextLevel = 0
                } else if let intValue = Int32(text), intValue >= 1 {
                    GuGramSettings.shared.customRatingInfoNextLevel = intValue
                }
            }, action: {
            })
        case let .customRatingInfoCurrentLevelInfinity(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.customRatingInfoCurrentLevelInfinity = value
            })
        case let .customRatingInfoNextLevelInfinity(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.customRatingInfoNextLevelInfinity = value
            })
        case let .hideGuGramSettingsEntry(_, text, value):
            return ItemListSwitchItem(presentationData: presentationData, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                GuGramSettings.shared.hideGuGramSettingsEntry = value
            })
        case let .info(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        }
    }
}

private func ratingBadgeShapeTitle(_ style: Int32) -> String {
    switch style {
    case 1:
        return "Fixed Level"
    case 2:
        return "Circle"
    case 3:
        return "Hex"
    case 4:
        return "Shield"
    case 5:
        return "Diamond"
    case 6:
        return "Star"
    default:
        return "Auto (By Level)"
    }
}

private func guGramSettingsControllerEntries(presentationData: PresentationData, state: GuGramSettings.State) -> [GuGramSettingsEntry] {
    var entries: [GuGramSettingsEntry] = []
    
    entries.append(.sectionHeader(presentationData.theme, "Core Features", .core))
    entries.append(.ghostMode(presentationData.theme, "Ghost Mode", state.ghostMode))
    entries.append(.localPremium(presentationData.theme, "Local Premium", state.localPremium))
    entries.append(.hideStories(presentationData.theme, "Hide Stories", state.hideStories))
    entries.append(.editedMessages(presentationData.theme, "Show Edit History", state.editedMessages))
    entries.append(.deletedMessages(presentationData.theme, "Show Deleted Messages & Chats", state.deletedMessages))
    entries.append(.bypassCopyProtection(presentationData.theme, "Bypass Copy Protection", state.bypassCopyProtection))

    entries.append(.sectionHeader(presentationData.theme, "Privacy", .privacy))
    entries.append(.hidePhoneNumber(presentationData.theme, "Hide Phone Number", state.hidePhoneNumber))
    entries.append(.hideUsername(presentationData.theme, "Hide Username", state.hideUsername))
    entries.append(.hideName(presentationData.theme, "Hide Name", state.hideName))
    entries.append(.hideAvatar(presentationData.theme, "Hide Avatar", state.hideAvatar))
    
    entries.append(.sectionHeader(presentationData.theme, "Identity", .identity))
    entries.append(.isCustomUsernameEnabled(presentationData.theme, "Enable Custom Username", state.isCustomUsernameEnabled))
    if state.isCustomUsernameEnabled {
        entries.append(.customUsername(presentationData.theme, "Username", state.customUsername))
    }

    entries.append(.isCustomNameEnabled(presentationData.theme, "Enable Custom Name", state.isCustomNameEnabled))
    if state.isCustomNameEnabled {
        entries.append(.customName(presentationData.theme, "Name", state.customName))
    }

    entries.append(.isCustomPhoneNumberEnabled(presentationData.theme, "Enable Custom Phone Number", state.isCustomPhoneNumberEnabled))
    if state.isCustomPhoneNumberEnabled {
        entries.append(.customPhoneNumber(presentationData.theme, "Phone Number", state.customPhoneNumber))
    }

    entries.append(.isCustomAvatarEnabled(presentationData.theme, "Enable Custom Avatar (Local)", state.isCustomAvatarEnabled))
    if state.isCustomAvatarEnabled {
        entries.append(.selectCustomAvatar(presentationData.theme, "Select Local Avatar"))
    }
    
    entries.append(.sectionHeader(presentationData.theme, "Rating Badge", .ratingBadge))
    entries.append(.hideRatingBadge(presentationData.theme, "Hide Rating Badge", state.hideRatingBadge))

    entries.append(.isCustomRatingBadgeEnabled(presentationData.theme, "Enable Custom Rating Badge", state.isCustomRatingBadgeEnabled))
    if state.isCustomRatingBadgeEnabled {
        entries.append(.customRatingBadgeInfinity(presentationData.theme, "Infinity (∞)", state.customRatingBadgeInfinity))
        if !state.customRatingBadgeInfinity {
            entries.append(.customRatingBadgeLevel(presentationData.theme, "Level (1-999)", state.customRatingBadgeLevel))
        }
        entries.append(.customRatingBadgeShape(presentationData.theme, "Shape", state.customRatingBadgeShapeStyle))
        if state.customRatingBadgeShapeStyle == 1 {
            entries.append(.customRatingBadgeShapeLevel(presentationData.theme, "Shape Level", state.customRatingBadgeShapeLevel))
        }
        entries.append(.customRatingBadgeColor(presentationData.theme, "Color (hex)", state.customRatingBadgeColor))
    }

    if state.isCustomRatingBadgeEnabled {
        entries.append(.sectionHeader(presentationData.theme, "Rating Info Screen", .ratingInfo))
        entries.append(.isCustomRatingInfoEnabled(presentationData.theme, "Override Rating Info Screen", state.isCustomRatingInfoEnabled))
        if state.isCustomRatingInfoEnabled {
            entries.append(.customRatingInfoCurrentStarsInfinity(presentationData.theme, "Current Reputation: Infinity (∞)", state.customRatingInfoCurrentStarsInfinity))
            if !state.customRatingInfoCurrentStarsInfinity {
                entries.append(.customRatingInfoCurrentStars(presentationData.theme, "Current Reputation", state.customRatingInfoCurrentStars))
            }
            entries.append(.customRatingInfoNextStarsInfinity(presentationData.theme, "Next Reputation: Infinity (∞)", state.customRatingInfoNextStarsInfinity))
            if !state.customRatingInfoNextStarsInfinity {
                entries.append(.customRatingInfoNextStars(presentationData.theme, "Reputation for Next Level", state.customRatingInfoNextStars))
            }
            entries.append(.customRatingInfoCurrentLevelInfinity(presentationData.theme, "Current Level: Infinity (∞)", state.customRatingInfoCurrentLevelInfinity))
            if !state.customRatingInfoCurrentLevelInfinity {
                entries.append(.customRatingInfoCurrentLevel(presentationData.theme, "Current Level", state.customRatingInfoCurrentLevel))
            }
            entries.append(.customRatingInfoNextLevelInfinity(presentationData.theme, "Next Level: Infinity (∞)", state.customRatingInfoNextLevelInfinity))
            if !state.customRatingInfoNextLevelInfinity {
                entries.append(.customRatingInfoNextLevel(presentationData.theme, "Next Level", state.customRatingInfoNextLevel))
            }
        }
    }

    entries.append(.sectionHeader(presentationData.theme, "About", .about))
    entries.append(.hideGuGramSettingsEntry(presentationData.theme, "Hide GuGram in Settings (restart to show)", state.hideGuGramSettingsEntry))
    entries.append(.info(presentationData.theme, "Local Premium unlocks client-side features like translations and icons.\n\nCustom Rating Badge: Set level 1-999 or use Infinity (∞). Choose a shape (Auto uses your level, Fixed Level locks a shape). Optional hex color (e.g. FF5500).\n\nRating Info Screen: Set current/next reputation and levels. Use Infinity toggles for ∞. Leave Next Level empty to auto +1; leave Next Reputation empty for max."))

    entries.sort()
    
    return entries
}

public func guGramSettingsController(context: AccountContext) -> ViewController {
    let arguments = GuGramSettingsControllerArguments(context: context, updateCustomUsername: { text in
        GuGramSettings.shared.customUsername = text
    }, selectCustomAvatar: {
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let actionSheet = ActionSheetController(presentationData: presentationData)
        actionSheet.setItemGroups([ActionSheetItemGroup(items: [
            ActionSheetButtonItem(title: "Choose from Gallery", color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                
                let completion: (UIImage?) -> Void = { image in
                    if let image = image {
                        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/gugram_custom_avatar.png"
                        if let data = image.pngData() {
                            try? data.write(to: URL(fileURLWithPath: path))
                            GuGramSettings.shared.customAvatarPath = path
                            GuGramSettings.shared.isCustomAvatarEnabled = true
                        }
                    }
                    currentImagePickerDelegate = nil
                }

                if #available(iOS 14.0, *) {
                    var configuration = PHPickerConfiguration()
                    configuration.filter = .images
                    configuration.selectionLimit = 1
                    
                    let picker = PHPickerViewController(configuration: configuration)
                    let delegate = ImagePickerDelegate(completion: completion)
                    currentImagePickerDelegate = delegate
                    picker.delegate = delegate
                    context.sharedContext.mainWindow?.hostView.containerView.window?.rootViewController?.present(picker, animated: true)
                } else {
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    let delegate = LegacyImagePickerDelegate(completion: completion)
                    currentImagePickerDelegate = delegate
                    picker.delegate = delegate
                    context.sharedContext.mainWindow?.hostView.containerView.window?.rootViewController?.present(picker, animated: true)
                }
            }),
            ActionSheetButtonItem(title: "Choose from Files", color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                
                let completion: (UIImage?) -> Void = { image in
                    if let image = image {
                        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/gugram_custom_avatar.png"
                        if let data = image.pngData() {
                            try? data.write(to: URL(fileURLWithPath: path))
                            GuGramSettings.shared.customAvatarPath = path
                            GuGramSettings.shared.isCustomAvatarEnabled = true
                        }
                    }
                    currentImagePickerDelegate = nil
                }

                let picker: UIDocumentPickerViewController
                if #available(iOS 14.0, *) {
                    picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image, .item])
                } else {
                    picker = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .import)
                }
                let delegate = DocumentPickerDelegate(completion: completion)
                currentImagePickerDelegate = delegate
                picker.delegate = delegate
                context.sharedContext.mainWindow?.hostView.containerView.window?.rootViewController?.present(picker, animated: true)
            }),
            ActionSheetButtonItem(title: "Clear Custom Avatar", color: .destructive, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                GuGramSettings.shared.customAvatarPath = nil
                GuGramSettings.shared.isCustomAvatarEnabled = false
            })
        ]), ActionSheetItemGroup(items: [
            ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
            })
        ])])
        context.sharedContext.mainWindow?.present(actionSheet, on: .root)
    }, selectRatingBadgeShape: {
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let actionSheet = ActionSheetController(presentationData: presentationData)
        let currentStyle = GuGramSettings.shared.customRatingBadgeShapeStyle
        let options: [(Int32, String)] = [
            (0, "Auto (By Level)"),
            (1, "Fixed Level"),
            (2, "Circle"),
            (3, "Hex"),
            (4, "Shield"),
            (5, "Diamond"),
            (6, "Star")
        ]
        let items = options.map { style, title in
            let label = style == currentStyle ? "\(title) ✓" : title
            return ActionSheetButtonItem(title: label, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                GuGramSettings.shared.customRatingBadgeShapeStyle = style
            })
        }
        actionSheet.setItemGroups([ActionSheetItemGroup(items: items), ActionSheetItemGroup(items: [
            ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
            })
        ])])
        context.sharedContext.mainWindow?.present(actionSheet, on: .root)
    })
    
    let signal: Signal<(ItemListControllerState, (ItemListNodeState, GuGramSettingsControllerArguments)), NoError> = combineLatest(queue: .mainQueue(), 
        context.sharedContext.presentationData,
        GuGramSettings.shared.settingsStateSignal
    )
    |> map { presentationData, state -> (ItemListControllerState, (ItemListNodeState, GuGramSettingsControllerArguments)) in
        let entries = guGramSettingsControllerEntries(presentationData: presentationData, state: state)
        
        let controllerState = ItemListControllerState(presentationData: ItemListPresentationData(presentationData), title: .text("GuGram Settings"), leftNavigationButton: nil, rightNavigationButton: nil, backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back))
        
        let listState = ItemListNodeState(presentationData: ItemListPresentationData(presentationData), entries: entries, style: .blocks)
        
        return (controllerState, (listState, arguments))
    }
    
    let controller = ItemListController(context: context, state: signal)
    return controller
}
