defmodule Auth.RegistrationControllerTest do
  use Auth.ConnCase, async: true

  alias Auth.Registration

  @valid_attrs %{
    country_code: "+7",
    unique_id: Ecto.UUID.generate,
    digits: "7471113457",
    region: "KZ"
  }

  test "/register creates new registration", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), registration: @valid_attrs
    assert json_response(conn, 200)
    assert [_registration] = Repo.all from r in Registration,
      where: r.country_code == ^@valid_attrs.country_code
        and r.digits == ^@valid_attrs.digits and r.unique_id == ^@valid_attrs.unique_id
  end

  test "/register updates already existing registration", %{conn: conn} do
    existing_registration = insert(:registration)
    conn = post conn, registration_path(conn, :create),
      registration: existing_registration |> Map.from_struct
    assert json_response(conn, 200)
    assert [_registration] = Repo.all from r in Registration,
      where: r.country_code == ^existing_registration.country_code
        and r.digits == ^existing_registration.digits and r.unique_id == ^existing_registration.unique_id
  end

  # test "/register sends sms via twilio if params are valid", %{conn: conn} do
    # with_mock Auth.ExTwilio.Message, [create: fn([to: to, from: _from, body: body]) ->
    #   assert to == @valid_attrs.country_code <> @valid_attrs.digits
    # end] do
    #   conn = post conn, registration_path(conn, :create), registration: @valid_attrs
    #   assert json_response(conn, 200)
    #   # TODO does not work for some reason
    #   assert called Auth.ExTwilio.Message.create
    # end
  # end

  # Errors section
  test "/register sends error if country_code is not of appropriate format", %{conn: conn} do
    conn = post conn, registration_path(conn, :create),
      registration: Map.put(@valid_attrs, "country_code", "123123123")
    assert json_response(conn, 422) == %{"errors" => %{"registration" => ["invalid input"]}}
  end

  test "/register sends error if digits is not of appropriate format", %{conn: conn} do
    conn = post conn, registration_path(conn, :create),
      registration: Map.put(@valid_attrs, "digits", "123123123123123123123")
    assert json_response(conn, 422) == %{"errors" => %{"registration" => ["invalid input"]}}
    refute Repo.get_by(Registration, @valid_attrs)
  end

  test "/register sends error if regions is not of appropriate format", %{conn: conn} do
    conn = post conn, registration_path(conn, :create),
      registration: Map.put(@valid_attrs, "region", "ADSD")
    assert json_response(conn, 422) == %{"errors" => %{"registration" => ["invalid input"]}}
    refute Repo.get_by(Registration, @valid_attrs)
  end

  test "/register sends error if unique_id is not of appropriate format", %{conn: conn} do
    conn = post conn, registration_path(conn, :create),
      registration: Map.put(@valid_attrs, "unique_id", "ADSD")
    assert json_response(conn, 422) == %{"errors" => %{"registration" => ["invalid input"]}}
    refute Repo.get_by(Registration, @valid_attrs)
  end

end
