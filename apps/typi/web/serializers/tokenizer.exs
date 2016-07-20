defmodule Typi.Tokenizer do

  alias Typi.{Repo, User}

  def encode_and_sign(account) do
    user = %User{
      account: account
    }
    |> Repo.insert!

    Guardian.encode_and_sign(user)
  end
end
