defmodule Auth.RegistrationView do
  use Auth.Web, :view

  def render("index.json", %{registrations: registrations}) do
    %{data: render_many(registrations, Auth.RegistrationView, "registration.json")}
  end

  def render("show.json", %{registration: registration}) do
    %{data: render_one(registration, Auth.RegistrationView, "registration.json")}
  end

  def render("registration.json", %{registration: registration}) do
    %{id: registration.id,
      country_code: registration.country_code,
      digits: registration.digits,
      region: registration.region,
      device_id: registration.device_id}
  end
end
