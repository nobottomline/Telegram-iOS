import Foundation
import UIKit
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
    
    init(context: AccountContext) {
        self.context = context
    }
}

private enum GuGramSettingsSection: Int32 {
    case main
}

private enum GuGramSettingsEntry: ItemListNodeEntry {
    case ghostMode(PresentationTheme, String, Bool)
    case localPremium(PresentationTheme, String, Bool)
    case hideStories(PresentationTheme, String, Bool)
    case info(PresentationTheme, String)
    
    var section: ItemListSectionId {
        return GuGramSettingsSection.main.rawValue
    }
    
    var stableId: Int32 {
        switch self {
        case .ghostMode: return 0
        case .localPremium: return 1
        case .hideStories: return 2
        case .info: return 3
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
        case let .info(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        }
    }
}

private func guGramSettingsControllerEntries(presentationData: PresentationData, ghostMode: Bool, localPremium: Bool, hideStories: Bool) -> [GuGramSettingsEntry] {
    var entries: [GuGramSettingsEntry] = []
    
    entries.append(.ghostMode(presentationData.theme, "Ghost Mode", ghostMode))
    entries.append(.localPremium(presentationData.theme, "Local Premium", localPremium))
    entries.append(.hideStories(presentationData.theme, "Hide Stories", hideStories))
    entries.append(.info(presentationData.theme, "Local Premium unlocks client-side features like translations and icons."))
    
    return entries
}

public func guGramSettingsController(context: AccountContext) -> ViewController {
    let arguments = GuGramSettingsControllerArguments(context: context)
    
    let signal = combineLatest(queue: .mainQueue(), 
        context.sharedContext.presentationData,
        GuGramSettings.shared.ghostModeSignal,
        GuGramSettings.shared.localPremiumSignal,
        GuGramSettings.shared.hideStoriesSignal
    )
    |> map { presentationData, ghostMode, localPremium, hideStories -> (ItemListControllerState, (ItemListNodeState, Any)) in
        let entries = guGramSettingsControllerEntries(presentationData: presentationData, ghostMode: ghostMode, localPremium: localPremium, hideStories: hideStories)
        
        let controllerState = ItemListControllerState(presentationData: ItemListPresentationData(presentationData), title: .text("GuGram Settings"), leftNavigationButton: nil, rightNavigationButton: nil, backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back))
        
        let listState = ItemListNodeState(presentationData: ItemListPresentationData(presentationData), entries: entries, style: .blocks)
        
        return (controllerState, (listState, arguments))
    }
    
    let controller = ItemListController(context: context, state: signal)
    return controller
}
