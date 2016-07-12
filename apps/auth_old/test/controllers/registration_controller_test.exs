defmodule Auth.RegistrationControllerTest do
  use Auth.ConnCase

  alias Auth.Registration
  @valid_attrs %{country_code: "some content", device_id: "some content", digits: "some content", region: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "/register creates new registration", %{conn: conn} do
    # conn = post conn, "/register", registration: @register_attrs
    IO.inspect conn
    conn =
      conn
      |> put_req_header("method", "post")
      |> Auth.Router.call(conn, @valid_attrs)
    assert json_response(conn, 200)
    assert [registration] = Repo.all from r in Registration,
      where: r.country_code == ^@valid_attrs.country_code
        and r.number == ^@valid_attrs.number and r.uuid == ^@valid_attrs.uuid
  end
end
