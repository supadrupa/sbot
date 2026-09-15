import telegram/api
import telegram/bot.{type Context}
import telegram/model/types.{type Message, SendMessageParameters}

pub fn with_text(ctx ctx: Context, text text: String) -> Result(Message, Nil) {
  api.send_message(
    ctx.client,
    parameters: SendMessageParameters(text:, chat_id: ctx.chat_id),
  )
}
