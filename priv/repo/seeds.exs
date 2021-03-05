# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
[
  %{
    "name" => "fulano",
    "username" => "fulano",
    "email" => "fulano@fulano.com",
    "age" => "25",
    "password" => "123456"
  },
  %{
    "name" => "ciclano",
    "username" => "ciclano",
    "email" => "ciclano@ciclano.com",
    "age" => "20",
    "password" => "123456"
  }
]
|> Enum.map(&Rocketpay.create_user/1)
