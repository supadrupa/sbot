import gleam/dynamic/decode
import gleam/http/response.{type Response}
import gleam/json
import gleam/result
import telegram/client.{fetch}
import telegram/model/decoder
import telegram/model/encoder
import telegram/model/types.{
  type GetUpdatesParameters, type Message, type SendMessageParameters,
  type Update,
}

type ApiResponse(result) {
  ApiSuccessResponse(ok: Bool, result: result)
}

pub fn send_message(
  client client: client.TelegramClient,
  parameters parameters: SendMessageParameters,
) -> Result(Message, Nil) {
  let body_json = encoder.encode_send_message_parameters(parameters)

  fetch(client: client, path: "sendMessage", body: json.to_string(body_json))
  |> map_response(decoder.message_decoder())
}

pub fn get_updates(
  client client: client.TelegramClient,
  parameters parameters: GetUpdatesParameters,
) -> Result(List(Update), Nil) {
  let body_json = encoder.encode_get_updates_parameters(parameters)

  fetch(client: client, path: "getUpdates", body: json.to_string(body_json))
  |> map_response(decode.list(decoder.update_decoder()))
}

fn map_response(
  response: Result(Response(String), Nil),
  result_decoder: decode.Decoder(a),
) {
  use response <- result.try(response)
  json.parse(response.body, response_decoder(result_decoder))
  |> result.map_error(fn(_) { Nil })
  |> result.try(fn(response) {
    case response {
      ApiSuccessResponse(result: result, ..) -> {
        Ok(result)
      }
    }
  })
}

fn response_decoder(result_decoder: decode.Decoder(a)) {
  use ok <- decode.field("ok", decode.bool)
  use result <- decode.field("result", result_decoder)
  decode.success(ApiSuccessResponse(ok:, result:))
}
