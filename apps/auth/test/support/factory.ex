defmodule Auth.Factory do
  use ExMachina.Ecto, repo: Auth.Repo

  alias Auth.Registration

  def registration_factory do
    %Registration{
      country_code: "+7",
      device_id: Ecto.UUID.generate,
      digits: "7471113457",
      region: "KZ"
    }
  end
end
