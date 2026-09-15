import gleam/option.{type Option, None, Some}

import telegram/client.{type FetchClient, type TelegramClient}
import telegram/model/types.{type Update as UpdateModel}

pub type Context {
  Context(chat_id: Int, update: Update, client: TelegramClient)
}

pub type Update {
  TextUpdate(chat_id: Int, text: String)
  CommandUpdate(chat_id: Int, command: String)
}

fn to_update(update: UpdateModel) -> Option(Update) {
  case update.message {
    Some(message) ->
      case message.text {
        Some(text) -> Some(TextUpdate(chat_id: message.chat.id, text: text))

        None -> None
      }

    None -> None
  }
}

pub type Handler {
  HandleAll(fn(Context, Update) -> Result(Context, Nil))
  HandleText(fn(Context, String) -> Result(Context, Nil))
  HandleCommand(fn(Context, String) -> Result(Context, Nil))
}

fn dispatch_handler(
  handler: Handler,
  ctx: Context,
  update: Update,
) -> Result(Context, Nil) {
  case handler, update {
    HandleAll(handler), update -> handler(ctx, update)

    HandleText(handler), TextUpdate(text:, ..) -> handler(ctx, text)

    HandleCommand(handler), CommandUpdate(command:, ..) -> handler(ctx, command)

    _, _ -> Error(Nil)
  }
}

pub type Bot {
  Bot(handler: Option(Handler), telegram_client: TelegramClient)
}

pub fn new(token: String, fetch_client: FetchClient) {
  Bot(handler: None, telegram_client: client.new(token, fetch_client))
}

pub fn handler(bot bot: Bot, handler handler: Handler) -> Bot {
  Bot(..bot, handler: Some(handler))
}

pub fn dispatch_update(bot bot: Bot, update update: UpdateModel) -> Nil {
  case bot.handler, to_update(update) {
    Some(handler), Some(update) -> {
      let ctx =
        Context(
          chat_id: update.chat_id,
          update: update,
          client: bot.telegram_client,
        )

      let _ = dispatch_handler(handler, ctx, update)
      Nil
    }

    _, _ -> Nil
  }
}
