defmodule Auth.RegistrationTest do
  use Auth.ModelCase

  alias Auth.Registration

  @valid_attrs %{country_code: "some content", device_id: "some content", digits: "some content", region: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Registration.changeset(%Registration{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Registration.changeset(%Registration{}, @invalid_attrs)
    refute changeset.valid?
  end
end
