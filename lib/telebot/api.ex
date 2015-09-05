require Telebot.Macro
defmodule Telebot.Api do
  use HTTPoison.Base

  @endpoint "https://api.telegram.org/bot"

  @doc """
  Method for testing your bot's auth token

  Info: https://core.telegram.org/bots/api#getme
  """
  def get_me, do: execute("getMe")

  @doc """
  Use this method to send text messages.
  On success, the sent Message is returned in the result of response.

  The reply_markup is a Map which holds ReplyKeyboardMarkup,
  ReplyKeyboardHide or ForceReply object representation. Please refer
  to the official api for further information.

  Example:
      keyboard = %{keyboard: [["key1"], ["key2"]]}
      Telebot.Api.send_message(cid, "hello", false, nil, keyboard)

  Info: https://core.telegram.org/bots/api#sendmessage
  """
  def send_message(chat_id, text, disable_web_page_preview \\ false,
                   reply_to_message_id \\ nil, reply_markup \\ nil)  do
    execute("sendMessage",
            {:form, [chat_id: chat_id, text: text,
                     disable_web_page_preview: disable_web_page_preview,
                     reply_to_message_id: reply_to_message_id,
                     reply_markup: reply_markup |> Poison.encode!]})
  end

  @doc """
  Use this method to forward messages of any kind.
  On success, the sent Message is returned in the result of response.

  Info: https://core.telegram.org/bots/api#forwardmessage
  """
  def forward_message(chat_id, from_chat_id, message_id) do
    execute("forwardMessage",
            {:form, [chat_id: chat_id, from_chat_id: from_chat_id,
                     message_id: message_id]})
  end

  @doc """
  Use this method to send photos.
  On success, the sent Message is returned in the result of response.

  The reply_markup is a Map which holds ReplyKeyboardMarkup,
  ReplyKeyboardHide or ForceReply object representation. Please refer
  to the official api for further information.

  Example:
      keyboard = %{keyboard: [["key1"], ["key2"]]}
      Telebot.Api.send_photo(cid, "/path/to/my/file", "Photo Caption", nil, keyboard)

  Info: https://core.telegram.org/bots/api#sendphoto
  """
  def send_photo(chat_id, path, caption \\ nil, reply_to_message_id \\ nil,
                 reply_markup \\ nil) do
    fparam = file_param(:photo, path)
    params = [chat_id: chat_id, caption: caption,
             reply_to_message_id: reply_to_message_id,
             reply_markup: (reply_markup |> Poison.encode!)]
    execute("sendPhoto", multipart_file(fparam, params))
  end

  @doc """
  Use this method to send audio files. if you want Telegram clients to display
  them in the music player. Your audio must be in the .mp3 format. On success,
  the sent Message is returned in the result of response.

  Bots can currently send audio files of up to 50 MB in size, this limit may be
  changed in the future.

  The reply_markup is a Map which holds ReplyKeyboardMarkup,
  ReplyKeyboardHide or ForceReply object representation. Please refer
  to the official api for further information.

  Example:
      keyboard = %{keyboard: [["key1"], ["key2"]]}
      Telebot.Api.send_audio(cid, "/path/to/my/file.mp3", 60, "Singer", "Title", nil, keyboard)

  Info: https://core.telegram.org/bots/api#sendaudio
  """
  def send_audio(chat_id, path, duration \\ nil, performer \\ nil, title \\ nil,
                 reply_to_message_id \\ nil, reply_markup \\ nil) do
    fparam = file_param(:audio, path)
    params = [chat_id: chat_id, duration: duration,
              performer: performer, title: title,
              reply_to_message_id: reply_to_message_id,
              reply_markup: (reply_markup |> Poison.encode!)]
    execute("sendAudio", multipart_file(fparam, params))
  end

  @doc """
  Use this method to send general files.
  On success, the sent Message is returned in the result of response.

  Bots can currently send files of up to 50 MB in size, this limit may be
  changed in the future.

  Example:
      keyboard = %{keyboard: [["key1"], ["key2"]]}
      Telebot.Api.send_document(cid, "/path/to/my/file", nil, keyboard)

  Info: https://core.telegram.org/bots/api#senddocument
  """
  def send_document(chat_id, path, reply_to_message_id \\ nil,
                    reply_markup \\ nil) do
    fparam = file_param(:document, path)
    params = [chat_id: chat_id, 
              reply_to_message_id: reply_to_message_id,
              reply_markup: (reply_markup |> Poison.encode!)]
    execute("sendDocument", multipart_file(fparam, params))
  end

  @doc """
  Use this method to send .webp stickers
  On success, the sent Message is returned in the result of response.

  The reply_markup is a Map which holds ReplyKeyboardMarkup,
  ReplyKeyboardHide or ForceReply object representation. Please refer
  to the official api for further information.

  Example:
      keyboard = %{keyboard: [["key1"], ["key2"]]}
      Telebot.Api.send_sticker(cid, "/path/to/my/file.webp", nil, keyboard)

  Info: https://core.telegram.org/bots/api#sendsticker
  """
  def send_sticker(chat_id, path, reply_to_message_id \\ nil,
                    reply_markup \\ nil) do
    fparam = file_param(:sticker, path)
    params = [chat_id: chat_id, 
              reply_to_message_id: reply_to_message_id,
              reply_markup: (reply_markup |> Poison.encode!)]
    execute("sendSticker", multipart_file(fparam, params))
  end

  @doc """
  Use this method to send video files, Telegram clients support mp4 videos
  (other formats may be sent as Document).
  On success, the sent Message is returned in the result of response.

  Bots can currently send files of up to 50 MB in size, this limit may be
  changed in the future.

  The reply_markup is a Map which holds ReplyKeyboardMarkup,
  ReplyKeyboardHide or ForceReply object representation. Please refer
  to the official api for further information.

  Example:
      keyboard = %{keyboard: [["key1"], ["key2"]]}
      Telebot.Api.send_video(cid, "/path/to/my/file.mp4", 60, "Caption", nil, keyboard)

  Info: https://core.telegram.org/bots/api#sendvideo
  """
  def send_video(chat_id, path, duration \\ nil, caption \\ nil,
                 reply_to_message_id \\ nil, reply_markup \\ nil) do
    fparam = file_param(:video, path)
    params = [chat_id: chat_id, duration: duration, caption: caption,
              reply_to_message_id: reply_to_message_id,
              reply_markup: (reply_markup |> Poison.encode!)]
    execute("sendVideo", multipart_file(fparam, params))
  end

  @doc """
  Use this method to send audio files, if you want Telegram clients to display
  the file as a playable voice message. For this to work, your audio must be in
  an .ogg file encoded with OPUS
  (other formats may be sent as Audio or Document).
  On success, the sent Message is returned in the result of response.

  Bots can currently send voice messages of up to 50 MB in size, this limit may
  be changed in the future.

  The reply_markup is a Map which holds ReplyKeyboardMarkup,
  ReplyKeyboardHide or ForceReply object representation. Please refer
  to the official api for further information.

  Example:
      keyboard = %{keyboard: [["key1"], ["key2"]]}
      Telebot.Api.send_voice(cid, "/path/to/my/file.ogg", 10, nil, keyboard)

  Info: https://core.telegram.org/bots/api#sendvoice
  """
  def send_voice(chat_id, path, duration \\ nil,
                 reply_to_message_id \\ nil, reply_markup \\ nil) do
    fparam = file_param(:voice, path)
    params = [chat_id: chat_id, duration: duration,
              reply_to_message_id: reply_to_message_id,
              reply_markup: (reply_markup |> Poison.encode!)]
    execute("sendVoice", multipart_file(fparam, params))
  end

  @doc """
  User this method to send point on the map.
  On success, the sent Message is returned in the result of response.

  The reply_markup is a Map which holds ReplyKeyboardMarkup,
  ReplyKeyboardHide or ForceReply object representation. Please refer
  to the official api for further information.

  Example:
      keyboard = %{keyboard: [["key1"], ["key2"]]}
      Telebot.Api.send_locatoin(cid, 1.816, 4.0e-6, nil, keyboard)

  Info: https://core.telegram.org/bots/api#sendlocation
  """
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

  @doc """
  Use this method when you need to tell the user that something is happening
  on the bot's side. The status is set for 5 seconds or less (when a message
  arrives from your bot, Telegram clients clear its typing status).

  Example: The ImageBot needs some time to process a request and upload the image.
  Instead of sending a text message along the lines of “Retrieving image, please
  wait…”, the bot may use sendChatAction with action = upload_photo. The user will
  see a “sending photo” status for the bot.

  The parameter action can be the following atoms,

  :typing | :upload_photo | :record_video | :upload_video | :record_audio | :upload_audio | upload_document | find_location

      Telebot.Api.send_chat_action(cid, :typing)

  Info: https://core.telegram.org/bots/api#sendchataction
  """
  def send_chat_action(chat_id, action) do
    execute("sendChatAction", {:form, [chat_id: chat_id, action: action]})
  end

  @doc """
  Use this method to get a list of profile pictures for a user.
  Returns a UserProfilePhotos map in the result of response.

  Info: https://core.telegram.org/bots/api#getuserprofilephotos
  """
  def get_user_profile_photos(user_id, offset \\ 0, limit \\ 100) do
    execute("getUserProfilePhotos", {:form, [user_id: user_id, offset: offset,
                                            limit: limit]})
  end

  @doc """
  Use this method to receive incoming updates using long polling.
  An Array of Update objects is returned in the result of response.

  Info: https://core.telegram.org/bots/api#getupdates
  """
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
