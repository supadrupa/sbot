import envoy
import gleam/erlang/process
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/httpc
import gleam/result
import telegram/bot

pub fn fetch_adapter(req: Request(String)) -> Result(Response(String), Nil) {
  httpc.send(req)
  |> result.map_error(fn(_) { Nil })
}

fn bot_handler(ctx, updatxe) {
  todo
}

pub fn main() {
  let token = case envoy.get("BOT_TOKEN") {
    Ok(token) -> token
    Error(_) -> panic as "BOT_TOKEN is not set"
  }
  let _ =
    bot.new(token, fetch_adapter)
    |> bot.handler(bot_handler)
    |> bot.start_polling()

  process.sleep_forever()
}
