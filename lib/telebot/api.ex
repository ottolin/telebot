require Telebot.Macro
defmodule Telebot.Api do
  use HTTPoison.Base

  @endpoint "https://api.telegram.org/bot"
  #@exp_fields [:result]

  #def run(api_key, url, params \\ %{}) do
  #  get((api_key <> "/" <> url), [], params: params)
  #end

  def get_me, do: execute("getMe")

  def send_message(chat_id, text, disable_web_page_preview \\ false, reply_to_message_id \\ nil, reply_markup \\ nil)  do
    param = {:form,[chat_id: chat_id, text: text, disable_web_page_preview: disable_web_page_preview,
                    reply_to_message_id: reply_to_message_id, reply_markup: reply_markup |> Poison.encode!]}
    execute("sendMessage", param)
  end

  def forward_message(chat_id, from_chat_id, message_id) do
    execute("forwardMessage", {:form, [chat_id: chat_id, from_chat_id: from_chat_id, message_id: message_id]})
  end

  def get_updates(offset \\ 0, limit \\ 100, timeout \\ 0) do
    execute("getUpdates", {:form, [offset: offset, limit: limit, timeout: timeout]})
  end

  #TODO: sending files

  defp execute(method, params \\ []) do
    post(method, params)
  end

  defp process_url(url) do
    @endpoint <> Application.get_env(:telebot, :api_key) <> "/" <> url
  end

  defp process_response_body(body) do
    body
    |> Poison.decode!(keys: :atoms)
    #|> Dict.take(@exp_fields)
  end
end
