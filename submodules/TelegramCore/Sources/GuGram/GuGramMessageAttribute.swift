import Postbox

public final class GuGramEditHistoryEntry: PostboxCoding, Equatable {
    public let text: String
    public let entities: [MessageTextEntity]
    public let editTimestamp: Int32
    
    public init(text: String, entities: [MessageTextEntity], editTimestamp: Int32) {
        self.text = text
        self.entities = entities
        self.editTimestamp = editTimestamp
    }
    
    public init(decoder: PostboxDecoder) {
        self.text = decoder.decodeStringForKey("t", orElse: "")
        self.entities = decoder.decodeObjectArrayWithDecoderForKey("e")
        self.editTimestamp = decoder.decodeInt32ForKey("d", orElse: 0)
    }
    
    public func encode(_ encoder: PostboxEncoder) {
        encoder.encodeString(self.text, forKey: "t")
        encoder.encodeObjectArray(self.entities, forKey: "e")
        encoder.encodeInt32(self.editTimestamp, forKey: "d")
    }
    
    public static func ==(lhs: GuGramEditHistoryEntry, rhs: GuGramEditHistoryEntry) -> Bool {
        return lhs.text == rhs.text && lhs.entities == rhs.entities && lhs.editTimestamp == rhs.editTimestamp
    }
}

public class GuGramMessageAttribute: MessageAttribute {
    public var isDeleted: Bool
    public var isPreserved: Bool
    public var originalText: String?
    public var editHistory: [GuGramEditHistoryEntry]

    public init(
        isDeleted: Bool = false,
        isPreserved: Bool = false,
        originalText: String? = nil,
        editHistory: [GuGramEditHistoryEntry] = []
    ) {
        self.isDeleted = isDeleted
        self.isPreserved = isPreserved
        self.originalText = originalText
        self.editHistory = editHistory
    }

    public required init(decoder: PostboxDecoder) {
        self.isDeleted = decoder.decodeBoolForKey("gg_isDeleted", orElse: false)
        self.isPreserved = decoder.decodeBoolForKey("gg_isPreserved", orElse: false)
        self.originalText = decoder.decodeOptionalStringForKey("gg_originalText")
        self.editHistory = decoder.decodeObjectArrayWithDecoderForKey("gg_editHistory")
    }

    public func encode(_ encoder: PostboxEncoder) {
        encoder.encodeBool(isDeleted, forKey: "gg_isDeleted")
        encoder.encodeBool(isPreserved, forKey: "gg_isPreserved")
        if let originalText {
            encoder.encodeString(originalText, forKey: "gg_originalText")
        }
        if !self.editHistory.isEmpty {
            encoder.encodeObjectArray(self.editHistory, forKey: "gg_editHistory")
        }
    }
    
    public func clone() -> GuGramMessageAttribute {
        return GuGramMessageAttribute(isDeleted: self.isDeleted, isPreserved: self.isPreserved, originalText: self.originalText, editHistory: self.editHistory)
    }
}

public final class GuGramEditHistoryMessageAttribute: MessageAttribute {
    public let originMessageId: MessageId
    public let editTimestamp: Int32
    
    public var associatedMessageIds: [MessageId] {
        return [self.originMessageId]
    }
    
    public init(originMessageId: MessageId, editTimestamp: Int32) {
        self.originMessageId = originMessageId
        self.editTimestamp = editTimestamp
    }
    
    public required init(decoder: PostboxDecoder) {
        let namespaceAndId: Int64 = decoder.decodeInt64ForKey("i", orElse: 0)
        let peerId = PeerId(decoder.decodeInt64ForKey("p", orElse: 0))
        self.originMessageId = MessageId(peerId: peerId, namespace: Int32(namespaceAndId & 0xffffffff), id: Int32((namespaceAndId >> 32) & 0xffffffff))
        self.editTimestamp = decoder.decodeInt32ForKey("d", orElse: 0)
    }
    
    public func encode(_ encoder: PostboxEncoder) {
        let namespaceAndId = Int64(self.originMessageId.namespace) | (Int64(self.originMessageId.id) << 32)
        encoder.encodeInt64(namespaceAndId, forKey: "i")
        encoder.encodeInt64(self.originMessageId.peerId.toInt64(), forKey: "p")
        encoder.encodeInt32(self.editTimestamp, forKey: "d")
    }
}

public extension Message {
    var gugramAttribute: GuGramMessageAttribute {
        for attribute in self.attributes {
            if let gugramAttribute = attribute as? GuGramMessageAttribute {
                return gugramAttribute
            }
        }
        return GuGramMessageAttribute()
    }
    
    var guGramEditHistoryMessageAttribute: GuGramEditHistoryMessageAttribute? {
        for attribute in self.attributes {
            if let attribute = attribute as? GuGramEditHistoryMessageAttribute {
                return attribute
            }
        }
        return nil
    }
    
    var isGuGramEditHistoryMessage: Bool {
        return self.guGramEditHistoryMessageAttribute != nil
    }
}

public extension Transaction {
    func updateGuGramAttribute(messageId: MessageId, _ block: (inout GuGramMessageAttribute) -> Void) {
        self.updateMessage(messageId) { message in
            var attributes = message.attributes
            attributes.updateGuGramAttribute(block)

            return .update(StoreMessage(id: message.id, customStableId: nil, globallyUniqueId: message.globallyUniqueId, groupingKey: message.groupingKey, threadId: message.threadId, timestamp: message.timestamp, flags: StoreMessageFlags(message.flags), tags: message.tags, globalTags: message.globalTags, localTags: message.localTags, forwardInfo: message.forwardInfo.map(StoreMessageForwardInfo.init), authorId: message.author?.id, text: message.text, attributes: attributes, media: message.media))
        }
    }
}

public extension StoreMessage {
    func updatingGuGramAttributeOnEdit(
        previousMessage: Message
    ) -> StoreMessage {
        let newAttr = self.attributes.compactMap { $0 as? GuGramMessageAttribute }.first
        let attr = (newAttr ?? previousMessage.gugramAttribute).clone()
        
        let previousText = previousMessage.text
        let previousEntities = previousMessage.textEntitiesAttribute?.entities ?? []
        let currentText = self.text
        let currentEntities = (self.attributes.first(where: { $0 is TextEntitiesMessageAttribute }) as? TextEntitiesMessageAttribute)?.entities ?? []
        
        if previousText != currentText || previousEntities != currentEntities {
            var editTimestamp = self.timestamp
            if let editedAttribute = self.attributes.first(where: { $0 is EditedMessageAttribute }) as? EditedMessageAttribute {
                editTimestamp = editedAttribute.date
            }
            
            if !(previousText.isEmpty && previousEntities.isEmpty) {
                let entry = GuGramEditHistoryEntry(text: previousText, entities: previousEntities, editTimestamp: editTimestamp)
                
                if attr.editHistory.last != entry {
                    attr.editHistory.append(entry)
                }
                
                if attr.originalText == nil {
                    attr.originalText = previousText
                }
            }
            
            if attr.editHistory.count > 20 {
                attr.editHistory.removeFirst(attr.editHistory.count - 20)
            }
        }
        
        var attributes = self.attributes
        attributes.updateGuGramAttribute {
            $0 = attr
        }
        
        return self.withUpdatedAttributes(attributes)
    }
}

private extension Array<MessageAttribute> {
    mutating func updateGuGramAttribute(
        _ block: (inout GuGramMessageAttribute) -> Void
    ) {
        for (index, attribute) in self.enumerated() {
            if var gugramAttribute = attribute as? GuGramMessageAttribute {
                block(&gugramAttribute)
                self[index] = gugramAttribute
                return
            }
        }

        var gugramAttribute = GuGramMessageAttribute()
        block(&gugramAttribute)
        self.append(gugramAttribute)
    }
}
