defmodule Auth.RegistrationController do
  use Auth.Web, :controller

  alias Auth.Registration

  def create(conn, %{"registration" => registration_params}) do
    changeset = Registration.changeset(%Registration{}, registration_params)

    case Repo.insert(changeset) do
      {:ok, registration} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", registration_path(conn, :show, registration))
        |> render("show.json", registration: registration)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Auth.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
