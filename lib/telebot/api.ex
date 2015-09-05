require Telebot.Macro
defmodule Telebot.Api do
  use HTTPoison.Base

  @endpoint "https://api.telegram.org/bot"

  def get_me, do: execute("getMe")

  def send_message(chat_id, text, disable_web_page_preview \\ false,
                   reply_to_message_id \\ nil, reply_markup \\ nil)  do
    execute("sendMessage",
            {:form, [chat_id: chat_id, text: text,
                     disable_web_page_preview: disable_web_page_preview,
                     reply_to_message_id: reply_to_message_id,
                     reply_markup: reply_markup |> Poison.encode!]})
  end

  def forward_message(chat_id, from_chat_id, message_id) do
    execute("forwardMessage",
            {:form, [chat_id: chat_id, from_chat_id: from_chat_id,
                     message_id: message_id]})
  end

  def send_photo(chat_id, path, caption \\ nil, reply_to_message_id \\ nil,
                 reply_markup \\ nil) do
    fparam = file_param(:photo, path)
    params = [chat_id: chat_id, caption: caption,
             reply_to_message_id: reply_to_message_id,
             reply_markup: (reply_markup |> Poison.encode!)]
    execute("sendPhoto", multipart_file(fparam, params))
  end

  def send_audio(chat_id, path, duration \\ nil, performer \\ nil, title \\ nil,
                 reply_to_message_id \\ nil, reply_markup \\ nil) do
    fparam = file_param(:audio, path)
    params = [chat_id: chat_id, duration: duration,
              performer: performer, title: title,
              reply_to_message_id: reply_to_message_id,
              reply_markup: (reply_markup |> Poison.encode!)]
    execute("sendAudio", multipart_file(fparam, params))
  end

  def send_document(chat_id, path, reply_to_message_id \\ nil,
                    reply_markup \\ nil) do
    fparam = file_param(:document, path)
    params = [chat_id: chat_id, 
              reply_to_message_id: reply_to_message_id,
              reply_markup: (reply_markup |> Poison.encode!)]
    execute("sendDocument", multipart_file(fparam, params))
  end

  def send_sticker(chat_id, path, reply_to_message_id \\ nil,
                    reply_markup \\ nil) do
    fparam = file_param(:sticker, path)
    params = [chat_id: chat_id, 
              reply_to_message_id: reply_to_message_id,
              reply_markup: (reply_markup |> Poison.encode!)]
    execute("sendSticker", multipart_file(fparam, params))
  end

  def send_video(chat_id, path, duration \\ nil, caption \\ nil,
                 reply_to_message_id \\ nil, reply_markup \\ nil) do
    fparam = file_param(:video, path)
    params = [chat_id: chat_id, duration: duration, caption: caption,
              reply_to_message_id: reply_to_message_id,
              reply_markup: (reply_markup |> Poison.encode!)]
    execute("sendVideo", multipart_file(fparam, params))
  end

  def send_voice(chat_id, path, duration \\ nil,
                 reply_to_message_id \\ nil, reply_markup \\ nil) do
    fparam = file_param(:voice, path)
    params = [chat_id: chat_id, duration: duration,
              reply_to_message_id: reply_to_message_id,
              reply_markup: (reply_markup |> Poison.encode!)]
    execute("sendVoice", multipart_file(fparam, params))
  end

  def send_location(chat_id, latitude, longitude,
                    reply_to_message_id \\ nil, reply_markup \\ nil) do
    IO.puts "" <> to_string(chat_id) <> " " <> to_string(latitude) <> " " <> to_string(longitude)
    execute("sendLocation",
            {:form, [chat_id: chat_id,
                     latitude: to_string(latitude),
                     longitude: to_string(longitude),
                     reply_to_message_id: reply_to_message_id,
                     reply_markup: reply_markup |> Poison.encode!]})
  end

  def send_chat_action(chat_id, action) do
    execute("sendChatAction", {:form, [chat_id: chat_id, action: action]})
  end

  def get_user_profile_photos(user_id, offset \\ 0, limit \\ 100) do
    execute("getUserProfilePhotos", {:form, [user_id: user_id, offset: offset,
                                            limit: limit]})
  end

  def get_updates(offset \\ 0, limit \\ 100, timeout \\ 0) do
    execute("getUpdates", {:form, [offset: offset, limit: limit,
                                   timeout: timeout]})
  end

  defp execute(method, params \\ []) do
    post(method, params)
  end

  defp file_param(file_type, path) do
    if File.exists? path do
      {:file, path,
       {"form-data", [name: file_type, filename: Path.basename(path)]},
       []}
    else
      raise "File: " <> path <> " not exists."
    end
  end

  defp multipart_file(fparam, params) do
    rv = {:multipart,
     params |> Enum.reduce([fparam],
      fn {k, v}, acc ->
        [{to_string(k), to_string(v)} | acc]
      end)
    }
    IO.inspect rv
    rv
  end

  defp process_url(url) do
    @endpoint <> Application.get_env(:telebot, :api_key) <> "/" <> url
  end

  defp process_status_code(403) do
    raise "Invalid api_key. Please make sure you vaild telegram bot key at :telebot, :api_key in config.exs"
  end

  defp process_status_code(s), do: s

  defp process_response_body(body) do
    body
    |> Poison.decode!(keys: :atoms)
  end
end
