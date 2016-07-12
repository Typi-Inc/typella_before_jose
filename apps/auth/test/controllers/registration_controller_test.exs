defmodule Auth.RegistrationControllerTest do
  use Auth.ConnCase

  alias Auth.Registration
  @valid_attrs %{country_code: "some content", device_id: "some content", digits: "some content", region: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, registration_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    registration = Repo.insert! %Registration{}
    conn = get conn, registration_path(conn, :show, registration)
    assert json_response(conn, 200)["data"] == %{"id" => registration.id,
      "country_code" => registration.country_code,
      "digits" => registration.digits,
      "region" => registration.region,
      "device_id" => registration.device_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, registration_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), registration: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Registration, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), registration: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    registration = Repo.insert! %Registration{}
    conn = put conn, registration_path(conn, :update, registration), registration: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Registration, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    registration = Repo.insert! %Registration{}
    conn = put conn, registration_path(conn, :update, registration), registration: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    registration = Repo.insert! %Registration{}
    conn = delete conn, registration_path(conn, :delete, registration)
    assert response(conn, 204)
    refute Repo.get(Registration, registration.id)
  end
end
