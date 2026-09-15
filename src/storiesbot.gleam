import envoy
import gleam/erlang/process
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/httpc
import gleam/result
import telegram/bot.{HandleText}
import telegram/polling
import telegram/reply

pub fn fetch_adapter(req: Request(String)) -> Result(Response(String), Nil) {
  httpc.send(req)
  |> result.map_error(fn(_) { Nil })
}

fn bot_handler(ctx, text) {
  let assert Ok(_) = reply.with_text(ctx, text)
  Ok(ctx)
}

pub fn main() {
  let token = case envoy.get("BOT_TOKEN") {
    Ok(token) -> token
    Error(_) -> panic as "BOT_TOKEN is not set"
  }
  let _ =
    bot.new(token, fetch_adapter)
    |> bot.handler(HandleText(bot_handler))
    |> polling.start_polling()

  process.sleep_forever()
}
