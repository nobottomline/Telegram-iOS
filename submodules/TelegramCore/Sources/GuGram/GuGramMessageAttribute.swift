import Postbox

public class GuGramMessageAttribute: MessageAttribute {
    public var isDeleted: Bool
    public var originalText: String?

    public init(
        isDeleted: Bool = false,
        originalText: String? = nil
    ) {
        self.isDeleted = isDeleted
        self.originalText = originalText
    }

    public required init(decoder: PostboxDecoder) {
        self.isDeleted = decoder.decodeBoolForKey("gg_isDeleted", orElse: false)
        self.originalText = decoder.decodeOptionalStringForKey("gg_originalText")
    }

    public func encode(_ encoder: PostboxEncoder) {
        encoder.encodeBool(isDeleted, forKey: "gg_isDeleted")
        if let originalText {
            encoder.encodeString(originalText, forKey: "gg_originalText")
        }
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
        let attr = newAttr ?? previousMessage.gugramAttribute

        if attr.originalText == nil {
            attr.originalText = previousMessage.text
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
