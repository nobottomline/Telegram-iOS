import Foundation
import UIKit
import PhotosUI
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
    
    init(context: AccountContext, updateCustomUsername: @escaping (String) -> Void, selectCustomAvatar: @escaping () -> Void) {
        self.context = context
        self.updateCustomUsername = updateCustomUsername
        self.selectCustomAvatar = selectCustomAvatar
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

private var currentImagePickerDelegate: NSObject?

private enum GuGramSettingsSection: Int32 {
    case main
}

private enum GuGramSettingsEntry: ItemListNodeEntry {
    case ghostMode(PresentationTheme, String, Bool)
    case localPremium(PresentationTheme, String, Bool)
    case hideStories(PresentationTheme, String, Bool)
    case editedMessages(PresentationTheme, String, Bool)
    case bypassCopyProtection(PresentationTheme, String, Bool)
    case hidePhoneNumber(PresentationTheme, String, Bool)
    case hideUsername(PresentationTheme, String, Bool)
    case hideName(PresentationTheme, String, Bool)
    case hideAvatar(PresentationTheme, String, Bool)
    case customUsername(PresentationTheme, String, String)
    case isCustomUsernameEnabled(PresentationTheme, String, Bool)
    case customName(PresentationTheme, String, String)
    case isCustomNameEnabled(PresentationTheme, String, Bool)
    case isCustomAvatarEnabled(PresentationTheme, String, Bool)
    case selectCustomAvatar(PresentationTheme, String)
    case hideRatingBadge(PresentationTheme, String, Bool)
    case info(PresentationTheme, String)
    
    var section: ItemListSectionId {
        return GuGramSettingsSection.main.rawValue
    }
    
    var stableId: Int32 {
        switch self {
        case .ghostMode: return 0
        case .localPremium: return 1
        case .hideStories: return 2
        case .editedMessages: return 3
        case .bypassCopyProtection: return 4
        case .hidePhoneNumber: return 5
        case .hideUsername: return 6
        case .hideName: return 7
        case .hideAvatar: return 8
        case .isCustomUsernameEnabled: return 9
        case .customUsername: return 10
        case .isCustomNameEnabled: return 11
        case .customName: return 12
        case .isCustomAvatarEnabled: return 13
        case .selectCustomAvatar: return 14
        case .hideRatingBadge: return 15
        case .info: return 16
        }
    }
    
    static func ==(lhs: GuGramSettingsEntry, rhs: GuGramSettingsEntry) -> Bool {
        switch lhs {
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
        case let .info(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        }
    }
}

private func guGramSettingsControllerEntries(presentationData: PresentationData, state: GuGramSettings.State) -> [GuGramSettingsEntry] {
    var entries: [GuGramSettingsEntry] = []
    
    entries.append(.ghostMode(presentationData.theme, "Ghost Mode", state.ghostMode))
    entries.append(.localPremium(presentationData.theme, "Local Premium", state.localPremium))
    entries.append(.hideStories(presentationData.theme, "Hide Stories", state.hideStories))
    entries.append(.editedMessages(presentationData.theme, "Edit History", state.editedMessages))
    entries.append(.bypassCopyProtection(presentationData.theme, "Bypass Copy Protection", state.bypassCopyProtection))
    entries.append(.hidePhoneNumber(presentationData.theme, "Hide Phone Number", state.hidePhoneNumber))
    entries.append(.hideUsername(presentationData.theme, "Hide Username", state.hideUsername))
    entries.append(.hideName(presentationData.theme, "Hide Name", state.hideName))
    entries.append(.hideAvatar(presentationData.theme, "Hide Avatar", state.hideAvatar))
    
    entries.append(.isCustomUsernameEnabled(presentationData.theme, "Enable Custom Username", state.isCustomUsernameEnabled))
    if state.isCustomUsernameEnabled {
        entries.append(.customUsername(presentationData.theme, "Username", state.customUsername))
    }

    entries.append(.isCustomNameEnabled(presentationData.theme, "Enable Custom Name", state.isCustomNameEnabled))
    if state.isCustomNameEnabled {
        entries.append(.customName(presentationData.theme, "Name", state.customName))
    }

    entries.append(.isCustomAvatarEnabled(presentationData.theme, "Enable Custom Avatar (Local)", state.isCustomAvatarEnabled))
    if state.isCustomAvatarEnabled {
        entries.append(.selectCustomAvatar(presentationData.theme, "Select Local Avatar"))
    }
    
    entries.append(.hideRatingBadge(presentationData.theme, "Hide Rating Badge", state.hideRatingBadge))
    
    entries.append(.info(presentationData.theme, "Local Premium unlocks client-side features like translations and icons."))
    
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
                            // Force update by toggling or just setting the same value to trigger signal
                            GuGramSettings.shared.isCustomAvatarEnabled = GuGramSettings.shared.isCustomAvatarEnabled
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
            ActionSheetButtonItem(title: "Clear Custom Avatar", color: .destructive, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                GuGramSettings.shared.customAvatarPath = nil
                GuGramSettings.shared.isCustomAvatarEnabled = GuGramSettings.shared.isCustomAvatarEnabled
            })
        ]), ActionSheetItemGroup(items: [
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
