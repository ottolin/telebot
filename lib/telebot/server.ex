defmodule Telebot.Server do
  use GenServer

  defstruct update_offset: 0,
  handlers: []

  def start_link({_handlers} = args, _opts) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

 # def get(call, param \\ %{}) do
 #   GenServer.call(__MODULE__, {:get, {call, param}})
 # end

  def info do
    GenServer.call(__MODULE__, :info)
  end

  def tick do
    GenServer.call(__MODULE__, :tick)
  end

  def tick(offset) do
    GenServer.call(__MODULE__, {:tick, offset})
  end

  # server callback
  def init({handlers}) do
    HTTPoison.start
    # Get initial offset
    {:ok, resp} = Telebot.Api.get_updates
    offset = next_offset(resp, 0)
    {:ok, %Telebot.Server{update_offset: offset, handlers: handlers}}
  end

 # def handle_call({:get, {call, param}}, _from, state) do
 #   rv = case Api.run state.api_key, call, param do
 #     {:ok, resp} -> resp.body[:result]
 #        _ -> :error
 #   end
 #   {:reply, rv, state}
 # end

  def handle_call(:info, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:tick, from, state) do
    handle_call({:tick, state.update_offset}, from, state)
  end

  def handle_call({:tick, offset}, _from, state) do
    rv = Telebot.Api.get_updates offset
    state1 = case rv do
      {:ok, resp} ->
        for msg <- resp.body[:result] do
          for handler <- state.handlers do
            spawn fn -> handler.process(msg) end
          end
        end
        offset1 = next_offset(resp, offset)
        %{state | update_offset: offset1}
      _ -> state
    end
    {:reply, state1, state1}
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
