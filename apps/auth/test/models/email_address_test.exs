defmodule Auth.EmailAddressTest do
  use Auth.ModelCase

  alias Auth.EmailAddress

  @valid_attrs %{identifier: "some content", label: "some content", value: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = EmailAddress.changeset(%EmailAddress{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = EmailAddress.changeset(%EmailAddress{}, @invalid_attrs)
    refute changeset.valid?
  end
end
