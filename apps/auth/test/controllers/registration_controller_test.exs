defmodule Auth.RegistrationControllerTest do
  use Auth.ConnCase
  import Auth.Factory

  alias Auth.Registration
  @valid_attrs %{
    country_code: "some content",
    device_id: "some content",
    digits: "some content",
    region: "some content"
  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "/register creates new registration", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), registration: @valid_attrs
    assert json_response(conn, 200)
    assert [_registration] = Repo.all from r in Registration,
      where: r.country_code == ^@valid_attrs.country_code
        and r.digits == ^@valid_attrs.digits and r.device_id == ^@valid_attrs.device_id
  end

  test "/register updates already existing registration", %{conn: conn} do
    existing_registration = insert(:registration)
    conn = post conn, registration_path(conn, :create),
      registration: existing_registration |> Map.from_struct
    assert json_response(conn, 200)
    assert [_registration] = Repo.all from r in Registration,
      where: r.country_code == ^existing_registration.country_code
        and r.digits == ^existing_registration.digits and r.device_id == ^existing_registration.device_id
  end
end
