import gleam/http
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}

pub type FetchClient =
  fn(Request(String)) -> Result(Response(String), Nil)

pub opaque type TelegramClient {
  TelegramClient(
    /// The Telegram Bot API token.
    token: String,
    /// The Telegram Bot API URL. Default is "https://api.telegram.org".
    /// This is useful for running [a local server](https://core.telegram.org/bots/api#using-a-local-bot-api-server).
    base_url: String,
    /// The HTTP client to use.
    fetch_client: FetchClient,
  )
}

const telegram_url = "api.telegram.org"

pub fn new(
  token token: String,
  fetch_client fetch_client: FetchClient,
) -> TelegramClient {
  TelegramClient(token:, base_url: telegram_url, fetch_client:)
}

pub fn fetch(
  client client: TelegramClient,
  path path: String,
  body body: String,
) -> Result(Response(String), Nil) {
  let api_request =
    request.new()
    |> request.set_method(http.Post)
    |> request.set_host(client.base_url)
    |> request.set_path("/bot" <> client.token <> "/" <> path)
    |> request.set_body(body)
    |> request.set_header("Content-Type", "application/json")

  client.fetch_client(api_request)
}
