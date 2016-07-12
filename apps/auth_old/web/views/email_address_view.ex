defmodule Auth.EmailAddressView do
  use Auth.Web, :view

  def render("index.json", %{email_addresses: email_addresses}) do
    %{data: render_many(email_addresses, Auth.EmailAddressView, "email_address.json")}
  end

  def render("show.json", %{email_address: email_address}) do
    %{data: render_one(email_address, Auth.EmailAddressView, "email_address.json")}
  end

  def render("email_address.json", %{email_address: email_address}) do
    %{id: email_address.id,
      identifier: email_address.identifier,
      label: email_address.label,
      value: email_address.value,
      contact_id: email_address.contact_id,
      account_id: email_address.account_id}
  end
end
