defmodule Auth.AccountController do
  use Auth.Web, :controller
  require Logger

  alias Auth.{Account, Registration}

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
      {:ok, account} <- update_or_insert_account(account_params)
    do
      conn
      |> put_status(:created)
      |> json(%{jwt: "jwt"})
    else
      {:error, _reasons} ->
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
    # case {has_device(account, registration), has_phone(account, registration)} do
    #   {true, true} -> {:ok, account}
    #   {true, false} -> add_assoc(account, :phones, Registration.to_phone(registration))
    #   {false, true} -> add_assoc(account, :devices, Registration.to_device(registration))
    #   _ ->
    #     Logger.error "The following account seems to have have either device or phone " <>
    #     "from the following registration, however in reality has " <>
    #     "does not have both/n#{inspect account}/n#{inspect account_params}"
    # end
  end

  defp has_device(account, account_params) do

  end

  defp has_phone(account, account_params) do

  end
end
