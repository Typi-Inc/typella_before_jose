defmodule Auth.PostalAddressTest do
  use Auth.ModelCase

  alias Auth.PostalAddress

  @valid_attrs %{city: "some content", country: "some content", identifier: "some content", label: "some content", postal_code: "some content", state: "some content", street: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PostalAddress.changeset(%PostalAddress{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PostalAddress.changeset(%PostalAddress{}, @invalid_attrs)
    refute changeset.valid?
  end
end
