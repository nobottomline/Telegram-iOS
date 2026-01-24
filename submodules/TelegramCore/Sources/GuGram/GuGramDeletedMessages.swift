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

    /// Помечает диалог как сохраненный
    static func preserveChat(
        peerId: PeerId,
        transaction: Transaction
    ) {
        // Берем последнее сообщение в диалоге и помечаем его как сохраненное
        if let index = transaction.getTopPeerMessageIndex(peerId: peerId) {
            transaction.updateGuGramAttribute(messageId: index.id) {
                $0.isPreserved = true
            }
        }
    }

    /// Проверяет, нужно ли физически удалять диалог
    static func shouldDeleteDialog(
        peerId: PeerId,
        transaction: Transaction
    ) -> Bool {
        // Если у последнего сообщения есть флаг isPreserved или isDeleted, 
        // значит мы хотим сохранить этот чат в списке
        if let index = transaction.getTopPeerMessageIndex(peerId: peerId) {
            if let message = transaction.getMessage(index.id) {
                let attr = message.gugramAttribute
                if attr.isPreserved || attr.isDeleted {
                    return false
                }
            }
        }
        
        return true
    }

    /// Проверяет, помечен ли пир как сохраненный
    static func isPreserved(
        peerId: PeerId,
        transaction: Transaction
    ) -> Bool {
        if let index = transaction.getTopPeerMessageIndex(peerId: peerId) {
            if let message = transaction.getMessage(index.id) {
                return message.gugramAttribute.isPreserved
            }
        }
        return false
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
