defmodule Auth.AccountControllerTest do
  use Auth.ConnCase, async: true

  alias Auth.{Account, Device, PhoneNumber, Registration}

  @valid_attrs %{
    verification: %{
      country_code: "+7",
      digits: "7471113457",
      unique_id: Ecto.UUID.generate,
    },
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
    ],
    phone_numbers: [
      %{
        country_code: "+7",
        digits: "7471113457",
        identifier: Ecto.UUID.generate,
        region: "KZ",
        label: "mobile"
      }
    ]
  }
  @one_time_password_config Application.get_env(:auth, :pot)

  test "/verify responds with error if registration is not found", %{conn: conn} do
    conn = post conn, account_path(conn, :create), account: valid_attrs
    assert json_response(conn, 422) == %{"errors" => %{"verification" => ["bad input"]}}
  end

  test "/verify responds with error when incorrect country_code/number is passed", %{conn: conn} do
    registration = insert(:registration)
    attrs =
      valid_attrs
      |> update_phone_number_prop(:country_code, "+1")
    conn = post conn, account_path(conn, :create), account: attrs
    assert json_response(conn, 422) == %{"errors" => %{"verification" => ["bad input"]}}

    refute Repo.get_by(PhoneNumber, Map.take(registration, [:country_code, :digits, :region]))
    refute Repo.get_by(Device, Map.take(registration, [:unique_id]))
    assert [] = Repo.all from a in Account,
      join: d in assoc(a, :devices),
      where: d.unique_id == ^registration.unique_id
  end

  test "/verify responds with error if incorrect token is passed", %{conn: conn} do
    registration = insert(:registration)
    attrs =
      valid_attrs
      |> Map.merge(%{
        verification: %{
          token: valid_attrs.verification.token <> "1"
        }
      }, fn _k, v1, v2 -> Map.merge(v1, v2) end)
    conn = post conn, account_path(conn, :create), account: attrs
    assert json_response(conn, 422) == %{"errors" => %{"verification" => ["bad input"]}}

    refute Repo.get_by(PhoneNumber, Map.take(registration, [:country_code, :digits, :region]))
    refute Repo.get_by(Device, Map.take(registration, [:unique_id]))
    assert [] = Repo.all from a in Account,
      join: d in assoc(a, :devices),
      where: d.unique_id == ^registration.unique_id
  end

  test "/verify creates new account", %{conn: conn} do
    registration = insert(:registration)
    attrs =
      valid_attrs
      |> update_device_prop(:unique_id, registration.unique_id)
      |> update_phone_number_prop(:digits, registration.digits)
      # |> update_attrs(%{unique_id: registration.unique_id, digits: registration.digits})
    conn = post conn, account_path(conn, :create), account: attrs
    assert json_response(conn, 201)["jwt"]

    assert Repo.get_by(PhoneNumber, Map.take(registration, [:country_code, :digits, :region]))
    assert Repo.get_by(Device, Map.take(registration, [:device_id]))
    assert Repo.all from a in Account,
      join: d in assoc(a, :devices),
      where: d.unique_id == ^registration.unique_id
  end

  test "/verify sends token if account with device and phone already exists", %{conn: conn} do
    registration = insert(:registration)
    insert_account(registration)
    attrs =
      valid_attrs
      |> update_device_prop(:unique_id, registration.unique_id)
      |> update_phone_number_prop(:digits, registration.digits)
      # |> update_attrs(%{unique_id: registration.unique_id, digits: registration.digits})
    conn = post conn, account_path(conn, :create), account: attrs
    assert json_response(conn, 201)["jwt"]
    assert [_device] = Repo.all from d in Device, where: d.unique_id == ^registration.unique_id
    assert [_phone_number] = Repo.all from p in PhoneNumber,
      where: p.country_code == ^registration.country_code and p.digits == ^registration.digits

    assert [account] = Repo.all from a in Account,
      join: d in assoc(a, :devices),
      join: p in assoc(a, :phone_numbers),
      where: d.unique_id == ^registration.unique_id or
        (p.country_code == ^registration.country_code and p.digits == ^registration.digits),
      preload: [devices: d, phone_numbers: p]
    assert length(account.devices) == 1
    assert length(account.phone_numbers) == 1
  end

  test "/verify sends token and appends phone to account, when account does not contain phone", %{conn: conn} do
    registration = insert(:registration)
    insert_account(registration |> Map.put(:digits, get_different_digits(registration.digits)))
    attrs =
      valid_attrs
      |> update_device_prop(:unique_id, registration.unique_id)
      |> update_phone_number_prop(:digits, registration.digits)
      # |> update_attrs(%{unique_id: registration.unique_id, digits: registration.digits})
    conn = post conn, account_path(conn, :create), account: attrs
    assert json_response(conn, 201)["jwt"]
    assert [_device] = Repo.all from d in Device, where: d.unique_id == ^registration.unique_id
    assert [_phone_number] = Repo.all from p in PhoneNumber,
      where: p.country_code == ^registration.country_code and p.digits == ^registration.digits

    assert [account] = Repo.all from a in Account,
      join: d in assoc(a, :devices),
      join: p in assoc(a, :phone_numbers),
      where: d.unique_id == ^registration.unique_id or
        (p.country_code == ^registration.country_code and p.digits == ^registration.digits),
      preload: [devices: d, phone_numbers: p]
    assert length(account.devices) == 1
    assert length(account.phone_numbers) == 2
  end

  test "/verify sends token and appends device to account, when account does not contain device", %{conn: conn} do
    registration = insert(:registration)
    insert_account(registration |> Map.put(:unique_id, Ecto.UUID.generate))
    attrs =
      valid_attrs
      |> update_device_prop(:unique_id, registration.unique_id)
      |> update_phone_number_prop(:digits, registration.digits)
      # |> update_attrs(%{unique_id: registration.unique_id, digits: registration.digits})
    conn = post conn, account_path(conn, :create), account: attrs
    assert json_response(conn, 201)["jwt"]
    assert [_device] = Repo.all from d in Device, where: d.unique_id == ^registration.unique_id
    assert [_phone_number] = Repo.all from p in PhoneNumber,
      where: p.country_code == ^registration.country_code and p.digits == ^registration.digits

    assert [account] = Repo.all from a in Account,
      join: d in assoc(a, :devices),
      join: p in assoc(a, :phone_numbers),
      where: d.unique_id == ^registration.unique_id or
        (p.country_code == ^registration.country_code and p.digits == ^registration.digits),
      preload: [devices: d, phone_numbers: p]
    assert length(account.devices) == 2
    assert length(account.phone_numbers) == 1
  end

  test "/verify deletes registration when account is successfully created/updated", %{conn: conn} do
    registration = insert(:registration)
    attrs =
      valid_attrs
      |> update_phone_number_prop(:digits, registration.digits)
      |> update_device_prop(:unique_id, registration.unique_id)
    conn = post conn, account_path(conn, :create), account: attrs
    assert json_response(conn, 201)["jwt"]
    refute Repo.get(Registration, registration.id)
  end

  defp get_different_digits(digits) do
    digits
    |> String.to_integer
    |> Kernel.+(1)
    |> to_string
  end

  defp insert_account(registration) do
    %Account{
      phone_numbers: [
        params_for(:phone_number, digits: registration.digits)
      ],
      devices: [
        params_for(:device, unique_id: registration.unique_id)
      ]
    } |> Repo.insert!
  end

  defp update_device_prop(attrs, key, value) do
    attrs
    |> Map.merge(%{
      verification: attrs.verification |> Map.put(key, value),
      devices: [
        attrs.devices
        |> List.first
        |> Map.put(key, value)
      ]
    })
  end

  defp update_phone_number_prop(attrs, key, value) do
    attrs
    |> Map.merge(%{
      verification: attrs.verification |> Map.put(key, value),
      phone_numbers: [
        attrs.phone_numbers
        |> List.first
        |> Map.put(key, value)
      ]
    })
  end

  defp update_attrs(attrs, %{unique_id: unique_id, digits: digits}) do
    attrs
    |> Map.merge(%{
      verification: attrs.verification
                    |> Map.put(:unique_id, unique_id)
                    |> Map.put(:digits, digits),
      devices: [
        attrs.devices
        |> List.first
        |> Map.put(:unique_id, unique_id)
      ],
      phone_numbers: [
        attrs.phone_numbers
        |> List.first
        |> Map.put(:digits, digits)
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
