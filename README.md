Telebot
=======
[![Build Status](https://travis-ci.org/ottolin/telebot.svg?branch=master)](https://travis-ci.org/ottolin/telebot)

Telegram bot plugin system written in Elixir.

## Why Telegram bot?
Telegram is an instant messaging system which has a nice UI and fast server response.

By using Telegram server infrastructure to build your bot, you have a reliable communication
backend system for your application free of charge!

Also, Telegram bot api allow you to send customized keyboard to Telegram UI,
which is available for both mobile and web. This is so nice that you do not have
to create your own UI.

To ensure you can easily leverage the above things, this is where telebot kicks in.

### Sample use case: Creating a smart home control system
#### Vanilla approach
1. Creating a home VPN access (Of course you dont want your home appliance on the internet!)
2. Creating your own server to receive commands. e.g. json/http
3. Adding application logic to act upon receiving commands. e.g. Turning on air-conditioner
4. Creating UI to send the commands.

#### Using Telebot
1. Creating a Telegram bot account. (Once only)
2. Creating a Telebot handler which act upon receiving commands.

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

## Configuration
In order to work with Telegram server, you need an api key.
The key can be obtained by sending message to [BotFather](https://telegram.me/BotFather)

After obtaining your key, add the following lines to config.exs:
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
  def text(from, chat, t), do: Telebot.Api.send_message(chat.id, "Echo: " <> t)
end
```

Finally, add your bot module to config.exs:
```elixir
config :telebot, :handlers,
[MyEchoBot]
```

Enjoy your bot by running
```
iex -S mix
```

By sending messages to your registered bot account, you should now see the reply from bot!


