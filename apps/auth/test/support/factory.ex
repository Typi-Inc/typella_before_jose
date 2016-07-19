defmodule Auth.Factory do
  use ExMachina.Ecto, repo: Auth.Repo

  alias Auth.{Account, Device, PhoneNumber, Registration}

  def registration_factory do
    %Registration{
      country_code: "+7",
      unique_id: Ecto.UUID.generate,
      digits: "747111" <> random_digits,
      region: "KZ"
    }
  end

  def account_factory do
    %Account{}
  end

  def phone_number_factory do
    %PhoneNumber{
      country_code: "+7",
      digits: "747111" <> random_digits,
      identifier: Ecto.UUID.generate,
      region: "KZ",
      label: "mobile"
    }
  end

  def device_factory do
    %Device{
      manufacturer: "Apple",
      model: "iPhone 6",
      device_id: "iPhone7,2",
      system_name: "iPhone OS",
      system_version: "9.0",
      bundle_id: "com.learnium.mobile",
      version:  "1.1.0",
      readable_version: "1.1.0.89",
      device_name: "Becca's iPhone 6",
      user_agent: "Dalvik/2.1.0 (Linux; U; Android 5.1; Google Nexus 4 - 5.1.0 - API 22 - 768x1280 Build/LMY47D)",
      device_locale: "en-US",
      device_country: "US",
      instance_id: "",
      unique_id: Ecto.UUID.generate
    }
  end

  defp random_digits do
    :erlang.system_time(:micro_seconds)
    |> to_string
    |> String.slice(-4, 4)
  end
end
