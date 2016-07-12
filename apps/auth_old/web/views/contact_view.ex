defmodule Auth.ContactView do
  use Auth.Web, :view

  def render("index.json", %{contacts: contacts}) do
    %{data: render_many(contacts, Auth.ContactView, "contact.json")}
  end

  def render("show.json", %{contact: contact}) do
    %{data: render_one(contact, Auth.ContactView, "contact.json")}
  end

  def render("contact.json", %{contact: contact}) do
    %{id: contact.id,
      family_name: contact.family_name,
      given_name: contact.given_name,
      identifier: contact.identifier,
      thumbnail_image_data: contact.thumbnail_image_data,
      note: contact.note,
      organization_name: contact.organization_name,
      account_id: contact.account_id}
  end
end
