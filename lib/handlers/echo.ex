require Logger
defmodule Echo do
  use Telebot.Handler.Base

  def text(chat, t) do
    Logger.debug "Echo: recv text: " <> t
    Telebot.Api.send_message chat.id, "Echo: " <> t
  end

  def contact(chat, c) do
    {:ok, t} = Poison.encode(c)
    Logger.debug "Echo: recv contact: " <> t
    Telebot.Api.send_message chat.id, "Echo: " <> c.first_name <> " tel: " <> c.phone_number
  end

  def location(chat, l) do
    {:ok, t} = Poison.encode(l)
    Logger.debug "Echo: recv location: " <> t
    Telebot.Api.send_location chat.id, l.latitude, l.longitude
  end

end
