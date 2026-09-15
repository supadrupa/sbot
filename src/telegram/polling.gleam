import gleam/erlang/process
import gleam/list
import gleam/option.{Some}
import gleam/result
import telegram/api
import telegram/bot.{type Bot}
import telegram/model/types.{type Update, GetUpdatesParameters}

type PollingConfig {
  PollingConfig(bot: Bot, timeout: Int, limit: Int, poll_interval: Int)
}

fn create_polling_config(
  bot bot: Bot,
  timeout timeout: Int,
  limit limit: Int,
  poll_interval poll_interval: Int,
) -> PollingConfig {
  PollingConfig(bot:, timeout:, limit:, poll_interval:)
}

fn polling_loop(config: PollingConfig, offset: Int) {
  use updates <- result.try(api.get_updates(
    config.bot.telegram_client,
    parameters: GetUpdatesParameters(
      offset: Some(offset),
      limit: Some(config.limit),
      timeout: Some(config.timeout),
    ),
  ))
  let new_offset = calculate_new_offset(updates, offset)
  list.each(updates, fn(update) { bot.dispatch_update(config.bot, update) })
  process.sleep(config.poll_interval)
  polling_loop(config, new_offset)
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

pub fn start_polling(bot: Bot) {
  let config =
    create_polling_config(bot:, timeout: 30, limit: 100, poll_interval: 1000)

  polling_loop(config, 0)
}
