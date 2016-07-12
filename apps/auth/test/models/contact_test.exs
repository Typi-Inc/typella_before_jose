defmodule Auth.ContactTest do
  use Auth.ModelCase

  alias Auth.Contact

  @valid_attrs %{family_name: "some content", given_name: "some content", identifier: "some content", note: "some content", organization_name: "some content", thumbnail_image_data: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Contact.changeset(%Contact{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Contact.changeset(%Contact{}, @invalid_attrs)
    refute changeset.valid?
  end
end
