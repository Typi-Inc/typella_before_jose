defmodule Auth.RegistrationController do
  use Auth.Web, :controller
  require Logger

  alias Auth.Registration


  plug :scrub_params, "registration" when action in [:create]

  def create(conn, %{"registration" => registration_params}) do
    with \
      {:ok, changeset} <- validate_params(registration_params),
      {:ok, _registration} <- insert_if_needed(changeset)
    do
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
    |> Map.take([:country_code, :digits, :device_id])
    |> get_registration
    |> case do
      nil ->
        Repo.insert(changeset)
      registration ->
        {:ok, registration}
    end
  end

  defp get_registration(attrs) do
    Repo.get_by(Registration, attrs)
  end
end
