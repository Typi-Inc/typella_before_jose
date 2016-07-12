defmodule Auth.BirthdayTest do
  use Auth.ModelCase

  alias Auth.Birthday

  @valid_attrs %{day: 42, month: 42, year: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Birthday.changeset(%Birthday{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Birthday.changeset(%Birthday{}, @invalid_attrs)
    refute changeset.valid?
  end
end
