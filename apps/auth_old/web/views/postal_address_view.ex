defmodule Auth.PostalAddressView do
  use Auth.Web, :view

  def render("index.json", %{postal_addresses: postal_addresses}) do
    %{data: render_many(postal_addresses, Auth.PostalAddressView, "postal_address.json")}
  end

  def render("show.json", %{postal_address: postal_address}) do
    %{data: render_one(postal_address, Auth.PostalAddressView, "postal_address.json")}
  end

  def render("postal_address.json", %{postal_address: postal_address}) do
    %{id: postal_address.id,
      identifier: postal_address.identifier,
      city: postal_address.city,
      country: postal_address.country,
      label: postal_address.label,
      postal_code: postal_address.postal_code,
      state: postal_address.state,
      street: postal_address.street,
      contact_id: postal_address.contact_id,
      account_id: postal_address.account_id}
  end
end
