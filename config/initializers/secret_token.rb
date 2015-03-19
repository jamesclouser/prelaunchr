# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Prelaunchr::Application.config.secret_token = ENV["RAILS_SECRET"] || 'b69ddd16b97c384314fbda32767f4ca264dd312e1ce1fd5286e313174236568415901844c5442553461be65d7e66aab63a24d0f802ef8a2c61dab01095ba06c5'
Prelaunchr::Application.config.secret_key_base = ENV["RAILS_SECRET"] || '82f18ed83ffe367f3e046f49a6c4b0541112a3c826de1c13ef946631f6aba8294d93b4dd1462cbcd1a2f5cd6ca64401c7c0d2cb4793dc2640b4dff59c69bfed2'
