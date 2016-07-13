defmodule Auth.RegistrationControllerTest do
  use Auth.ConnCase

  alias Auth.Registration
  @valid_attrs %{country_code: "some content", device_id: "some content", digits: "some content", region: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "/register creates new registration", %{conn: conn} do
    conn = post conn, "/register", registration: @register_attrs
    assert json_response(conn, 200)
    assert [registration] = Repo.all from r in Registration,
      where: r.country_code == ^@valid_attrs.country_code
        and r.digits == ^@valid_attrs.number and r.digits == ^@valid_attrs.uuid
  end
end
