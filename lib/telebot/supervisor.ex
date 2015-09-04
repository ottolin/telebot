defmodule Telebot.Supervisor do
  @moduledoc false

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    import Supervisor.Spec
    handlers = Application.get_env(:telebot, :handlers)
    children = [
      worker(Telebot.Server, [{handlers}, []]),
      worker(Telebot.Tick, [])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
