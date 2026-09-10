import gleam/erlang/process
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/httpc
import gleam/result
import telegram/client
import telegram/model/types.{SendMessageParameters}
import telegram/polling

// fn handler(_req) {
//   response.new(200)
//   |> response.set_header("content-type", "text/plain")
//   |> response.set_body(mist.Bytes(bytes_tree.from_string("Hello from Mist")))
// }

pub fn fetch_adapter(req: Request(String)) -> Result(Response(String), Nil) {
  httpc.send(req)
  |> result.map_error(fn(_) { Nil })
}

pub fn main() {
  client.new("", fetch_adapter)
  |> polling.start_polling()

  // |> api.send_message(parameters: SendMessageParameters(
  //   chat_id: 134_877_905,
  //   text: "lol",
  // ))

  // case
  //   mist.new(handler)
  //   |> mist.bind("localhost")
  //   |> mist.port(4000)
  //   |> mist.start
  // {
  //   Ok(_) -> io.println("Server started on http://localhost:4000")
  //   Error(_) -> io.println("Failed to start server")
  // }
  process.sleep_forever()
}
