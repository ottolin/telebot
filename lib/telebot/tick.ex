require Logger
defmodule Telebot.Tick do
  def start_link do
    Logger.debug "Start Telebot ticking."
    pid = spawn_link fn -> do_tick end
    {:ok, pid}
  end

  defp do_tick do
    :timer.sleep(1000)
    Telebot.Server.tick
    do_tick
  end
end
