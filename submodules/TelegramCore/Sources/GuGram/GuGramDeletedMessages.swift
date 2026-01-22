import Foundation
import Postbox
import SwiftSignalKit

public struct GuGramDeletedMessages {}

public extension GuGramDeletedMessages {
    static var enabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: "gg_showDeletedMessages")
        } set {
            UserDefaults.standard.setValue(newValue, forKey: "gg_showDeletedMessages")
        }
    }
}

extension GuGramDeletedMessages {
    static func markMessagesAsDeleted(
        globalIds: [Int32],
        transaction: Transaction
    ) -> [Int32] {
        guard enabled else {
            return globalIds
        }

        var markedIds: [Int32] = []

        for globalId in globalIds {
            if let id = transaction.messageIdsForGlobalIds([globalId]).first {
                transaction.updateGuGramAttribute(messageId: id) {
                    if !$0.isDeleted {
                        $0.isDeleted = true
                        markedIds.append(globalId)
                    }
                }
            }
        }

        let unmarkedIds = Set(globalIds).subtracting(markedIds)

        return Array(unmarkedIds)
    }

    static func markMessagesAsDeleted(
        ids: [MessageId],
        transaction: Transaction
    ) -> [MessageId] {
        guard enabled else {
            return ids
        }

        var markedIds: [MessageId] = []

        for id in ids {
            transaction.updateGuGramAttribute(messageId: id) {
                if !$0.isDeleted {
                    $0.isDeleted = true
                    markedIds.append(id)
                }
            }
        }

        let unmarkedIds = Set(ids).subtracting(markedIds)

        return Array(unmarkedIds)
    }
}
