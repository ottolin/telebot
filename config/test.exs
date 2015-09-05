# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# A dummy key registered for running test
config :telebot, :api_key,
"126467806:AAGTWOjd3ZVqGzLadePtbwMRwMAPbdnDz1s"

config :telebot, :handlers,
[
  Echo,
]
