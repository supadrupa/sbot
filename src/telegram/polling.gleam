import gleam/erlang/process
import gleam/list
import gleam/option.{Some}
import gleam/result
import telegram/api
import telegram/client.{type TelegramClient}
import telegram/model/types.{type Update, GetUpdatesParameters}

type PollingConfig {
  PollingConfig(
    client: TelegramClient,
    timeout: Int,
    limit: Int,
    poll_interval: Int,
  )
}

fn create_config(
  client client: TelegramClient,
  timeout timeout: Int,
  limit limit: Int,
  poll_interval poll_interval: Int,
) -> PollingConfig {
  PollingConfig(client:, timeout:, limit:, poll_interval:)
}

fn loop(config: PollingConfig, offset: Int) {
  use updates <- result.try(api.get_updates(
    config.client,
    parameters: GetUpdatesParameters(
      offset: Some(offset),
      limit: Some(config.limit),
      timeout: Some(config.timeout),
    ),
  ))
  let new_offset = calculate_new_offset(updates, offset)
  process.sleep(config.poll_interval)
  loop(config, new_offset)
}

/// Calculate the next offset based on received updates
pub fn calculate_new_offset(updates: List(Update), current_offset: Int) -> Int {
  case updates {
    [] -> current_offset
    _ -> {
      case list.last(updates) {
        Ok(update) -> update.update_id + 1
        Error(_) -> current_offset
      }
    }
  }
}

pub fn start_polling(client client: TelegramClient) {
  let config =
    create_config(client:, timeout: 30, limit: 100, poll_interval: 1000)

  loop(config, 0)
}
