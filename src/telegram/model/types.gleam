//// This module contains all types from [Telegram Bot API](https://core.telegram.org/bots/api).

import gleam/option.{type Option}

pub type Update {
  Update(
    /// The update's unique identifier. Update identifiers start from a certain positive number and increase sequentially. This identifier becomes especially handy if you're using webhooks, since it allows you to ignore repeated updates or to restore the correct update sequence, should they get out of order. If there are no new updates for at least a week, then identifier of the next update will be chosen randomly instead of sequentially.
    update_id: Int,
    /// Optional. New incoming message of any kind - text, photo, sticker, etc.
    message: Option(Message),
  )
}

pub type Message {
  Message(
    /// Unique message identifier inside this chat. In specific instances (e.g., message containing a video sent to a big chat), the server might automatically schedule a message instead of sending it immediately. In such cases, this field will be 0 and the relevant message will be unusable until it is actually sent
    message_id: Int,
    /// Date the message was sent in Unix time. It is always a positive number, representing a valid date.
    date: Int,
    /// Optional. For text messages, the actual UTF-8 text of the message
    text: Option(String),
  )
}

pub type SendMessageParameters {
  SendMessageParameters(
    /// Unique identifier for the target chat or username of the target channel (in the format `@channelusername`)
    chat_id: Int,
    /// Text of the message to be sent, 1-4096 characters after entities parsing
    text: String,
  )
}

pub type GetUpdatesParameters {
  GetUpdatesParameters(
    /// Identifier of the first update to be returned. Must be greater by one than the highest among the identifiers of previously received updates. By default, updates starting with the earliest unconfirmed update are returned. An update is considered confirmed as soon as getUpdates is called with an offset higher than its update_id. The negative offset can be specified to retrieve updates starting from -offset update from the end of the updates queue. All previous updates will be forgotten.
    offset: Option(Int),
    /// Limits the number of updates to be retrieved. Values between 1-100 are accepted. Defaults to 100.
    limit: Option(Int),
    /// Timeout in seconds for long polling. Defaults to 0, i.e. usual short polling. Should be positive, short polling should be used for testing purposes only.
    timeout: Option(Int),
  )
}
