defmodule Auth.AccountController do
  use Auth.Web, :controller
  require Logger

  alias Auth.{Account, Device, PhoneNumber, Registration}

  @one_time_password_config Application.get_env(:auth, :pot)

  plug :scrub_params, "account" when action in [:create]

  def create(
    conn,
    %{
      "account" => %{
        "verification" => %{
          "country_code" => country_code,
          "unique_id" => unique_id,
          "digits" => digits,
          "token" => token
        }
      } = account_params
    }
  )
  do
    with \
      :ok <- validate_token(token),
      {:ok, registration} <- get_registration(country_code, unique_id, digits),
      {:ok, account} <- update_or_insert_account(account_params),
      {:ok, _registration} <- Repo.delete(registration)
    do
      conn
      |> put_status(:created)
      |> json(%{jwt: "jwt"})
    else
      {:error, reasons} ->
        Logger.warn """
          There was a problem when
          registration a new account for the following reasons: #{inspect reasons}
        """
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{"errors" => %{"verification" => ["bad input"]}})
    end
  end

  defp validate_token(token) do
    [
      secret: secret,
      expiration: expiration,
      token_length: token_length
    ] = @one_time_password_config

    is_valid = :pot.valid_totp(token, secret, [
      token_length: token_length,
      interval_length: expiration
    ])
    if is_valid do
      :ok
    else
      {:error, %{"errors" => %{"verification" => "invalid token"}}}
    end
  end

  defp get_registration(country_code, unique_id, digits) do
    case Repo.get_by(Registration, %{country_code: country_code, unique_id: unique_id, digits: digits}) do
      nil -> {:error, %{"errors" => %{"verification" => "not yet registered"}}}
      registration -> {:ok, registration}
    end
  end

  defp update_or_insert_account(account_params) do
    query = from a in Account,
      join: d in assoc(a, :devices),
      join: p in assoc(a, :phone_numbers),
      where: d.unique_id == ^account_params["verification"]["unique_id"] or
        (p.country_code == ^account_params["verification"]["country_code"] and
        p.digits == ^account_params["verification"]["digits"]),
      preload: [devices: d, phone_numbers: p]

      case Repo.all(query) do
        [] -> insert_account(account_params)
        [account] -> update_if_needed(account, account_params)
        _ ->
          Logger.error "the following account_params appears to have more then one " <>
            "corresponding account #{inspect account_params}"
          {:error, %{"errors" => %{"verification" => "server error please contact us"}}}
      end
  end

  defp insert_account(account_params) do
    %Account{}
    |> Account.changeset(account_params)
    |> Repo.insert
  end

  defp update_if_needed(account, account_params) do
    case {has_device(account, account_params), has_phone_number(account, account_params)} do
      {true, true} ->
        {:ok, account}
      {true, false} ->
        phone_number_changeset =
          account_params["phone_numbers"]
          |> List.first
          |> (&PhoneNumber.changeset(%PhoneNumber{}, &1)).()
        add_assoc(account, :phone_numbers, phone_number_changeset)
      {false, true} ->
        device_changeset =
          account_params["devices"]
          |> List.first
          |> (&Device.changeset(%Device{}, &1)).()
        add_assoc(account, :devices, device_changeset)
      _ ->
        Logger.error "The following account seems to have have either device or phone " <>
        "from the following registration, however in reality has " <>
        "does not have both/n#{inspect account}/n#{inspect account_params}"
    end
  end

  defp has_device(account, account_params) do
    contains?(account.devices, fn device ->
      device.unique_id == account_params["verification"]["unique_id"]
    end)
  end

  defp has_phone_number(account, account_params) do
    contains?(account.phone_numbers, fn phone_number ->
      phone_number.country_code == account_params["verification"]["country_code"]
      phone_number.digits == account_params["verification"]["digits"]
    end)

  end

  defp contains?(list, func) do
    Enum.filter(list, func)
    |> case do
      [] -> false
      _ -> true
    end
  end

  defp add_assoc(account, assoc_key, assoc_changeset) do
    children_changesets =
      Map.get(account, assoc_key)
      |> Enum.map(&Ecto.Changeset.change/1)
      |> Kernel.++([assoc_changeset])

    account
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(assoc_key, children_changesets)
    |> Repo.update
  end
end
