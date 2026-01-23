import Foundation
import Postbox
import SwiftSignalKit

public struct GuGramDeletedMessages {}

public extension GuGramDeletedMessages {
    static var enabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: "gg_showDeletedMessages") == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: "gg_showDeletedMessages")
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

        var protectedIds: [Int32] = []

        for globalId in globalIds {
            if let id = transaction.messageIdsForGlobalIds([globalId]).first {
                // Проверяем, существует ли сообщение
                if let _ = transaction.getMessage(id) {
                    transaction.updateGuGramAttribute(messageId: id) {
                        if !$0.isDeleted {
                            $0.isDeleted = true
                        }
                    }
                    // Защищаем сообщение от удаления (не важно, было ли оно уже помечено)
                    protectedIds.append(globalId)
                }
            }
        }

        // Возвращаем только ID сообщений, которые НЕ нужно защищать (т.е. не найдены в базе)
        let idsToDelete = Set(globalIds).subtracting(protectedIds)

        return Array(idsToDelete)
    }

    static func markMessagesAsDeleted(
        ids: [MessageId],
        transaction: Transaction
    ) -> [MessageId] {
        guard enabled else {
            return ids
        }

        var protectedIds: [MessageId] = []

        for id in ids {
            // Проверяем, существует ли сообщение
            if let _ = transaction.getMessage(id) {
                transaction.updateGuGramAttribute(messageId: id) {
                    if !$0.isDeleted {
                        $0.isDeleted = true
                    }
                }
                // Защищаем сообщение от удаления (не важно, было ли оно уже помечено)
                protectedIds.append(id)
            }
        }

        // Возвращаем только ID сообщений, которые НЕ нужно защищать (т.е. не найдены в базе)
        let idsToDelete = Set(ids).subtracting(protectedIds)

        return Array(idsToDelete)
    }
    
    /// Помечает сообщения в диапазоне как удаленные
    /// Используется для перехвата deleteMessagesInRange
    static func markMessagesInRangeAsDeleted(
        peerId: PeerId,
        namespace: MessageId.Namespace,
        minId: MessageId.Id,
        maxId: MessageId.Id,
        transaction: Transaction
    ) {
        guard enabled else {
            return
        }
        
        // Итерируем по всем сообщениям пира и помечаем те, что в диапазоне
        transaction.withAllMessages(peerId: peerId, namespace: namespace) { message in
            if message.id.id >= minId && message.id.id <= maxId {
                transaction.updateGuGramAttribute(messageId: message.id) {
                    if !$0.isDeleted {
                        $0.isDeleted = true
                    }
                }
            }
            return true // продолжаем итерацию
        }
    }
}
