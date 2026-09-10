//// This module contains all encoders for types [Telegram Bot API](https://core.telegram.org/bots/api).

import gleam/json.{type Json}
import gleam/list
import telegram/model/types.{
  type GetUpdatesParameters, type SendMessageParameters,
}

fn json_object_filter_nulls(entries: List(#(String, Json))) -> Json {
  let null = json.null()

  entries
  |> list.filter(fn(entry) {
    let #(_, value) = entry
    value != null
  })
  |> json.object
}

pub fn encode_send_message_parameters(
  send_message_parameters: SendMessageParameters,
) -> Json {
  json_object_filter_nulls([
    #("chat_id", json.int(send_message_parameters.chat_id)),
    #("text", json.string(send_message_parameters.text)),
  ])
}

pub fn encode_get_updates_parameters(params: GetUpdatesParameters) -> Json {
  json_object_filter_nulls([
    #("offset", json.nullable(params.offset, json.int)),
    #("limit", json.nullable(params.limit, json.int)),
    #("timeout", json.nullable(params.timeout, json.int)),
  ])
}
