defmodule Auth.Factory do
  use ExMachina.Ecto, repo: Auth.Repo

  alias Auth.Registration

  def registration_factory do
    %Registration{
      country_code: "+7",
      device_id: "7481D15D-C27C-4805-876F-D2C0D413CEBD",
      digits: "7471113457",
      region: "KZ"
    }
  end
end
