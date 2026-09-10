import gleam/dynamic/decode
import gleam/option.{None}
import telegram/model/types.{type Message, type Update, Message, Update}

pub fn update_decoder() -> decode.Decoder(Update) {
  use update_id <- decode.field("update_id", decode.int)
  decode.success(Update(update_id: update_id))
}

pub fn message_decoder() -> decode.Decoder(Message) {
  use message_id <- decode.field("message_id", decode.int)
  use date <- decode.field("date", decode.int)
  use text <- decode.optional_field(
    "text",
    None,
    decode.optional(decode.string),
  )
  decode.success(Message(message_id: message_id, date: date, text: text))
}
