defmodule Auth.BirthdayView do
  use Auth.Web, :view

  def render("index.json", %{birthdays: birthdays}) do
    %{data: render_many(birthdays, Auth.BirthdayView, "birthday.json")}
  end

  def render("show.json", %{birthday: birthday}) do
    %{data: render_one(birthday, Auth.BirthdayView, "birthday.json")}
  end

  def render("birthday.json", %{birthday: birthday}) do
    %{id: birthday.id,
      day: birthday.day,
      month: birthday.month,
      year: birthday.year,
      contact_id: birthday.contact_id,
      account_id: birthday.account_id}
  end
end
