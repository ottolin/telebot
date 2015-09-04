require Logger
defmodule Echo do
  use Telebot.Handler.Base

  def text(chat, t) do
    Logger.debug "Echo: recv text: " <> t
    resp chat, "Echo: " <> t
  end

  def contact(chat, c) do
    {:ok, t} = Poison.encode(c)
    Logger.debug "Echo: recv contact: " <> t
  end

  def location(chat, l) do
    {:ok, t} = Poison.encode(l)
    Logger.debug "Echo: recv location: " <> t
  end

  #TODO
end
