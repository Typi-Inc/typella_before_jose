defmodule Auth.AccountControllerTest do
  use Auth.ConnCase, async: true

  alias Auth.{Account, Device, PhoneNumber}

  @valid_attrs %{
    verification: %{
      country_code: "+7",
      digits: "7471113457",
      unique_id: Ecto.UUID.generate,
    },
    phone_numbers: [
      %{
        country_code: "+7",
        digits: "7471113457",
        identifier: Ecto.UUID.generate,
        region: "KZ",
        label: "mobile"
      }
    ],
    devices: [
      %{
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
    ]
  }
  @one_time_password_config Application.get_env(:auth, :pot)

  test "/verify sends error if registration is not found", %{conn: conn} do
    conn = post conn, account_path(conn, :create), account: valid_attrs
    assert json_response(conn, 422) == %{"errors" => %{"verification" => ["bad input"]}}
  end

  test "/verify creates new account", %{conn: conn} do
    registration = insert(:registration)
    conn = post conn, account_path(conn, :create), account: valid_attrs |> put_unique_id(registration.unique_id)
    assert json_response(conn, 201)["jwt"]

    assert Repo.get_by(PhoneNumber, Map.take(registration, [:country_code, :digits, :region]))
    assert Repo.get_by(Device, Map.take(registration, [:device_id]))
    assert Repo.all from a in Account,
      join: d in assoc(a, :devices),
      where: d.unique_id == ^registration.unique_id
  end

  defp put_unique_id(attrs, unique_id) do
    attrs
    |> Map.merge(%{
      verification: attrs.verification |> Map.put(:unique_id, unique_id),
      devices: [
        attrs.devices |> List.first |> Map.put(:unique_id, unique_id)
      ]
    })
  end

  defp valid_attrs do
    [
      secret: secret,
      expiration: expiration,
      token_length: token_length
    ] = @one_time_password_config

    token = :pot.totp(secret, [
      token_length: token_length,
      interval_length: expiration
    ])

    Map.merge(@valid_attrs, %{
      verification: %{
        token: token
      }
    }, fn _k, v1, v2 -> Map.merge(v1, v2) end)
  end
end
