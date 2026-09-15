import gleam/option.{type Option, None, Some}
import telegram/client.{type FetchClient, type TelegramClient}
import telegram/polling

pub type Update {
  Update
}

pub type Context {
  Context(chat_id: Int, update: Update, client: TelegramClient)
}

pub type HandlerFn =
  fn(Context, Update) -> Result(Context, Nil)

pub opaque type AppBuilder {
  AppBuilder(handler: Option(HandlerFn), telegram_client: TelegramClient)
}

pub fn new(token: String, fetch_client: FetchClient) {
  AppBuilder(handler: None, telegram_client: client.new(token, fetch_client))
}

pub fn handler(
  builder builder: AppBuilder,
  handler handler: HandlerFn,
) -> AppBuilder {
  AppBuilder(..builder, handler: Some(handler))
}

pub fn start_polling(builder builder: AppBuilder) {
  polling.start_polling(builder.telegram_client)
}
