import gleam/int
import telegram/api
import telegram/bot.{type Context}
import telegram/model/types.{type Message, SendMessageParameters}

pub fn with_text(ctx ctx: Context, text text: String) -> Result(Message, Nil) {
  let assert Ok(key) = int.parse(ctx.key)
  api.send_message(
    ctx.client,
    parameters: SendMessageParameters(text:, chat_id: key),
  )
}
