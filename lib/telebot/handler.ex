import Telebot.Macro
defmodule Telebot.Handler do
  use Behaviour
  defcallback process(message :: Map.t)

  # gen_callback macro will define a callback in the following form:
  # defcallback callback_name(chat :: Map.t, obj :: Map.t)
  gen_callback :text
  gen_callback :audio
  gen_callback :document
  gen_callback :photo
  gen_callback :sticker
  gen_callback :video
  gen_callback :voice
  gen_callback :caption
  gen_callback :contact
  gen_callback :location
  gen_callback :new_chat_participant
  gen_callback :left_chat_participant
  gen_callback :new_chat_title
  gen_callback :new_chat_photo
  gen_callback :delete_chat_photo
  gen_callback :group_chat_created
end

defmodule Telebot.Handler.Base do
  defmacro __using__(_) do
    quote do
      import Telebot.Macro
      use Behaviour
      @behaviour Telebot.Handler

      def process(m) do
        [
          :text,
          :audio,
          :document,
          :photo,
          :sticker,
          :video,
          :voice,
          :caption,
          :contact,
          :location,
          :new_chat_participant,
          :left_chat_participant,
          :new_chat_title,
          :new_chat_photo,
          :delete_chat_photo,
          :group_chat_created
        ]
        |> Enum.each(
          fn obj ->
            # normal messages
            if m[:message] != nil && m.message[obj] != nil do
              apply(__MODULE__, obj, [m.message.from, m.message.chat, m.message[obj]])
            end

            # channel_post messages
            if m[:channel_post] != nil && m.channel_post[obj] != nil do
              apply(__MODULE__, obj, [m.channel_post.from, m.channel_post.chat, m.channel_post[obj]])
            end
          end
        )
      end

      gen_call :text
      gen_call :audio
      gen_call :document
      gen_call :photo
      gen_call :sticker
      gen_call :video
      gen_call :voice
      gen_call :caption
      gen_call :contact
      gen_call :location
      gen_call :new_chat_participant
      gen_call :left_chat_participant
      gen_call :new_chat_title
      gen_call :new_chat_photo
      gen_call :delete_chat_photo
      gen_call :group_chat_created

      defoverridable Module.definitions_in(__MODULE__)
    end
  end
end
