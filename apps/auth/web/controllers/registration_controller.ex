defmodule Auth.RegistrationController do
  use Auth.Web, :controller
  require Logger

  alias Auth.Registration

  @one_time_password_config Application.get_env(:auth, :pot)
  @twilio_api Application.get_env(:auth, :twilio_api)
  @twilio_phone_number Application.get_env(:ex_twilio, :phone_number)

  plug :scrub_params, "registration" when action in [:create]

  def create(conn, %{"registration" => registration_params}) do
    with \
      {:ok, changeset} <- validate_params(registration_params),
      {:ok, _registration} <- insert_if_needed(changeset)
    do
      send_one_time_password(registration_params)
      conn
      |> put_status(:ok)
      |> json(%{})
    else
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: %{registration: ["invalid input"]}})
    end
  end

  defp validate_params(registration_params) do
    changeset =
      %Registration{}
      |> Registration.changeset(registration_params)

    if changeset.valid? do
      {:ok, changeset}
    else
      {:error, changeset}
    end
  end

  defp insert_if_needed(changeset) do
    changeset
    |> Ecto.Changeset.apply_changes
    |> Map.take([:country_code, :digits, :unique_id])
    |> get_registration
    |> case do
      nil ->
        Repo.insert(changeset)
      registration ->
        {:ok, registration}
    end
  end

  defp send_one_time_password(%{"country_code" => country_code, "digits" => digits}) do
    [
      secret: secret,
      expiration: expiration,
      token_length: token_length
    ] = @one_time_password_config

    token = :pot.totp(secret, [
      token_length: token_length,
      interval_length: expiration
    ])

    @twilio_api.Message.create([
      to: country_code <> digits,
      from: @twilio_phone_number,
      body: token
    ])
  end

  defp get_registration(attrs) do
    Repo.get_by(Registration, attrs)
  end
end
