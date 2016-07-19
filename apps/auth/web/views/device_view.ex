defmodule Auth.DeviceView do
  use Auth.Web, :view

  def render("index.json", %{devices: devices}) do
    %{data: render_many(devices, Auth.DeviceView, "device.json")}
  end

  def render("show.json", %{device: device}) do
    %{data: render_one(device, Auth.DeviceView, "device.json")}
  end

  def render("device.json", %{device: device}) do
    %{id: device.id,
      manufacturer: device.manufacturer,
      model: device.model,
      device_id: device.device_id,
      system_name: device.system_name,
      system_version: device.system_version,
      bundle_id: device.bundle_id,
      version: device.version,
      readable_version: device.readable_version,
      device_name: device.device_name,
      user_agent: device.user_agent,
      device_locale: device.device_locale,
      device_country: device.device_country,
      instance_id: device.instance_id,
      unique_id: device.unique_id,
      account_id: device.account_id}
  end
end
