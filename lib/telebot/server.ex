defmodule Telebot.Server do
  @doc """
  Telebot.Server is a GenServer which holds the latest update offset and a
  list of Telebot.Handler behaviour for processing the fetched updates.
  """

  use GenServer

  defstruct update_offset: 0,
  handlers: []

  @doc """
  The start_link call requires a list of Telebot.Handler as argument.
  The handlers will be called-back whenever new update is received.

  Telebot.Server will ALWAYS registered using module name.

  Example:
      Telebot.Server.start_link([Echo], nil)
  """
  def start_link({_handlers} = args, _opts) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @doc """
  Return the latest GenServer state
  """
  def info do
    GenServer.call(__MODULE__, :info)
  end

  @doc """
  By calling tick once, Telebot.Server will fetch updates from telegram server
  and callback all handlers for the updates.

  This is expected to be called in a loop (See Telebot.Tick).
  """
  def tick do
    GenServer.call(__MODULE__, :tick)
  end

  # server callback
  def init({handlers}) do
    HTTPoison.start
    {:ok, %Telebot.Server{update_offset: -1, handlers: handlers}}
  end

  def handle_call(:info, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:tick, from, state) do
    handle_call({:tick, state.update_offset}, from, state)
  end

  def handle_call({:tick, -1}, from, state) do
    # Get initial offset
    {:ok, resp} = Telebot.Api.get_updates
    offset = next_offset(resp, 0)
    handle_call({:tick, offset}, from, state)
  end

  def handle_call({:tick, offset}, _from, state) do
    if state.handlers != [] do
      rv = Telebot.Api.get_updates offset
      offset1 = case rv do
                 {:ok, resp} ->
                   for msg <- resp.body[:result] do
                     for handler <- state.handlers do
                       spawn fn -> handler.process(msg) end
                     end
                   end
                   next_offset(resp, offset)
                 _ -> offset
               end
      state1 = %{state | update_offset: offset1}
      {:reply, state1, state1}
    else
      {:reply, state, state}
    end
  end

  defp next_offset(resp, default) do
    offset = case resp.body[:result] do
               [] -> default
               nil -> default
               _ -> hd(Enum.take(resp.body.result, -1)).update_id + 1
             end

    offset
  end
end
