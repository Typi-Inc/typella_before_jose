defmodule Auth.PhoneNumberView do
  use Auth.Web, :view

  def render("index.json", %{phone_numbers: phone_numbers}) do
    %{data: render_many(phone_numbers, Auth.PhoneNumberView, "phone_number.json")}
  end

  def render("show.json", %{phone_number: phone_number}) do
    %{data: render_one(phone_number, Auth.PhoneNumberView, "phone_number.json")}
  end

  def render("phone_number.json", %{phone_number: phone_number}) do
    %{id: phone_number.id,
      country_code: phone_number.country_code,
      digits: phone_number.digits,
      identifier: phone_number.identifier,
      region: phone_number.region,
      label: phone_number.label,
      contact_id: phone_number.contact_id,
      account_id: phone_number.account_id}
  end
end
