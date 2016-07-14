defmodule Auth.RegistrationController do
  use Auth.Web, :controller
  require Logger

  alias Auth.Registration


  plug :scrub_params, "registration"

  def create(conn, %{"registration" => %{
      "country_code" => country_code,
      "digits" => digits,
      "region" => _,
      "device_id" => device_id
    } = registration_params})
  do
    registration = Repo.get_by(Registration, [
      country_code: country_code,
      digits: digits,
      device_id: device_id
    ])

    registration
    |> insert_if_nil(registration_params)
    |> case do
      {:ok, _registration} ->
        conn
        |> put_status(:ok)
        |> json(%{})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Auth.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp insert_if_nil(registration, attrs) do
    case registration do
      nil ->
        changeset =
          %Registration{}
          |> Registration.changeset(attrs)
        Repo.insert(changeset)
      registration ->
        {:ok, registration}
    end
  end

end
