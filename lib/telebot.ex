defmodule Telebot do
  use Application

  def start(_type, _args) do
    Telebot.Supervisor.start_link
  end
end
