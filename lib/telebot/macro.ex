defmodule Telebot.Macro do
  defmacro gen_callback(name) do
    quote do
      defcallback unquote(name)(chat :: Map.t, obj :: Mat.t)
    end
  end

  defmacro gen_call(name) do
    quote do
      def unquote(name)(chat, obj), do: :ok
    end
  end
end
