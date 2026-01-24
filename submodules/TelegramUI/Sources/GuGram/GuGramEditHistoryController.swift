import Foundation
import UIKit
import Display
import SwiftSignalKit
import Postbox
import TelegramCore
import TelegramPresentationData
import ItemListUI
import PresentationDataUtils
import AccountContext
import TelegramStringFormatting
import TextFormat

private final class GuGramEditHistoryControllerArguments {
    let context: AccountContext
    let message: Message
    
    init(context: AccountContext, message: Message) {
        self.context = context
        self.message = message
    }
}

private enum GuGramEditHistorySection: Int32 {
    case main
}

private enum GuGramEditHistoryEntry: ItemListNodeEntry {
    case header(PresentationTheme, String, Int32)
    case text(PresentationTheme, NSAttributedString, Int32)
    case info(PresentationTheme, String, Int32)
    
    var section: ItemListSectionId {
        return GuGramEditHistorySection.main.rawValue
    }
    
    var stableId: Int32 {
        switch self {
        case let .header(_, _, id):
            return id
        case let .text(_, _, id):
            return id
        case let .info(_, _, id):
            return id
        }
    }
    
    static func ==(lhs: GuGramEditHistoryEntry, rhs: GuGramEditHistoryEntry) -> Bool {
        switch lhs {
        case let .header(lhsTheme, lhsText, lhsId):
            if case let .header(rhsTheme, rhsText, rhsId) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsId == rhsId {
                return true
            }
            return false
        case let .text(lhsTheme, lhsText, lhsId):
            if case let .text(rhsTheme, rhsText, rhsId) = rhs, lhsTheme === rhsTheme, lhsText.string == rhsText.string, lhsId == rhsId {
                return true
            }
            return false
        case let .info(lhsTheme, lhsText, lhsId):
            if case let .info(rhsTheme, rhsText, rhsId) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsId == rhsId {
                return true
            }
            return false
        }
    }
    
    static func <(lhs: GuGramEditHistoryEntry, rhs: GuGramEditHistoryEntry) -> Bool {
        return lhs.stableId < rhs.stableId
    }
    
    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        switch self {
        case let .header(_, text, _):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .text(_, attributedText, _):
            guard let arguments = arguments as? GuGramEditHistoryControllerArguments else {
                return ItemListTextItem(presentationData: presentationData, text: .plain(attributedText.string), sectionId: self.section)
            }
            return ItemListTextItem(presentationData: presentationData, text: .custom(context: arguments.context, string: attributedText), sectionId: self.section)
        case let .info(_, text, _):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        }
    }
}

private func guGramEditHistoryAttributedText(presentationData: PresentationData, message: Message, text: String, entities: [MessageTextEntity]) -> NSAttributedString {
    let baseFontSize = presentationData.listsFontSize.baseDisplaySize
    let baseFont = Font.regular(baseFontSize)
    let boldFont = Font.semibold(baseFontSize)
    let italicFont = Font.italic(baseFontSize)
    let boldItalicFont = Font.semiboldItalic(baseFontSize)
    let fixedFont = Font.monospace(baseFontSize)
    let blockQuoteFont = baseFont
    
    return stringWithAppliedEntities(
        text,
        entities: entities,
        baseColor: presentationData.theme.list.itemPrimaryTextColor,
        linkColor: presentationData.theme.list.itemAccentColor,
        baseFont: baseFont,
        linkFont: baseFont,
        boldFont: boldFont,
        italicFont: italicFont,
        boldItalicFont: boldItalicFont,
        fixedFont: fixedFont,
        blockQuoteFont: blockQuoteFont,
        underlineLinks: false,
        message: message
    )
}

private func guGramEditHistoryControllerEntries(presentationData: PresentationData, arguments: GuGramEditHistoryControllerArguments) -> [GuGramEditHistoryEntry] {
    var entries: [GuGramEditHistoryEntry] = []
    
    let history = arguments.message.gugramAttribute.editHistory
    if history.isEmpty {
        entries.append(.info(presentationData.theme, "No edit history available.", 0))
        return entries
    }
    
    var stableId: Int32 = 0
    for entry in history.reversed() {
        let dateString = stringForMediumDate(timestamp: entry.editTimestamp, strings: presentationData.strings, dateTimeFormat: presentationData.dateTimeFormat, withTime: true)
        let headerText = "\(presentationData.strings.Conversation_MessageEditedLabel) \(dateString)"
        entries.append(.header(presentationData.theme, headerText, stableId))
        stableId += 1
        let attributedText = guGramEditHistoryAttributedText(presentationData: presentationData, message: arguments.message, text: entry.text, entities: entry.entities)
        entries.append(.text(presentationData.theme, attributedText, stableId))
        stableId += 1
    }
    
    entries.append(.info(presentationData.theme, "Only edits received on this device are shown.", stableId))
    
    return entries
}

public func guGramEditHistoryController(context: AccountContext, message: Message) -> ViewController {
    let arguments = GuGramEditHistoryControllerArguments(context: context, message: message)
    
    let signal = context.sharedContext.presentationData
    |> map { presentationData -> (ItemListControllerState, (ItemListNodeState, Any)) in
        let entries = guGramEditHistoryControllerEntries(presentationData: presentationData, arguments: arguments)
        let controllerState = ItemListControllerState(presentationData: ItemListPresentationData(presentationData), title: .text("Edit History"), leftNavigationButton: nil, rightNavigationButton: nil, backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back))
        let listState = ItemListNodeState(presentationData: ItemListPresentationData(presentationData), entries: entries, style: .blocks)
        return (controllerState, (listState, arguments))
    }
    
    let controller = ItemListController(context: context, state: signal)
    return controller
}
