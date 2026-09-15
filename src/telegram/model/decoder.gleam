import gleam/dynamic/decode
import gleam/option.{None}
import telegram/model/types.{
  type Chat, type Message, type Update, Chat, Message, Update,
}

pub fn update_decoder() -> decode.Decoder(Update) {
  use update_id <- decode.field("update_id", decode.int)
  use message <- decode.optional_field(
    "message",
    None,
    decode.optional(message_decoder()),
  )
  decode.success(Update(update_id: update_id, message:))
}

pub fn message_decoder() -> decode.Decoder(Message) {
  use message_id <- decode.field("message_id", decode.int)
  use date <- decode.field("date", decode.int)
  use chat <- decode.field("chat", chat_decoder())
  use text <- decode.optional_field(
    "text",
    None,
    decode.optional(decode.string),
  )
  decode.success(Message(message_id: message_id, date: date, chat:, text: text))
}

pub fn chat_decoder() -> decode.Decoder(Chat) {
  use id <- decode.field("id", decode.int)
  decode.success(Chat(id:))
}
