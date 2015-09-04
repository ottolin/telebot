Telebot
=======

Telegram bot plugin system written in Elixir.
Working in progress. File upload (e.g. video/audio) is not yet supported.

## Install
Add the following lines to mix.exs in your project
```elixir

def application do
  [applications: [:telebot]]
end

defp deps do
  [{:telebot, git: "git://github.com/ottolin/telebot.git"}]
end
```

Then update dependencies by:
```
mix deps.get
```

### Telebot configuration
In order to work with Telegram server, you need an api key.
The key can be obtained by sending message to ([BotFather]https://telegram.me/BotFather)
After obtaining your key, add the folloing line to config.exs
```elixir
config :telebot, :api_key,
"Your API Key Right Here"
```

Now you are able to write your own bot by implementing the behaviour Telebot.Handler.
To simplify this process, just use Telebot.Handler.Base and override any callback that you are interested in.
In the following example, you can have an echo Telegram bot in just a few lines of code.
```elixir
defmodule MyEchoBot do
  use Telebot.Handler.Base

  # overriding the text() callback
  def text(chat, t), do: resp(chat, "Echo: " <> t)
end
```

Finally, add your bot module to config.exs:
```elixir
config :telebot, :handlers,
[MyEchoBot]
```
