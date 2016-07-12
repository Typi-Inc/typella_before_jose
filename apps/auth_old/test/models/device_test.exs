defmodule Auth.DeviceTest do
  use Auth.ModelCase

  alias Auth.Device

  @valid_attrs %{bundle_id: "some content", device_country: "some content", device_id: "some content", device_locale: "some content", device_name: "some content", instance_id: "some content", manufacturer: "some content", model: "some content", readable_version: "some content", system_name: "some content", system_version: "some content", user_agent: "some content", version: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Device.changeset(%Device{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Device.changeset(%Device{}, @invalid_attrs)
    refute changeset.valid?
  end
end
