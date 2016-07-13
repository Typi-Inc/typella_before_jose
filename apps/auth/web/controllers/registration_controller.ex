defmodule Auth.RegistrationController do
  use Auth.Web, :controller

  alias Auth.Registration

  @valid_attrs %{
    "country_code": "+1",
    "region": "US",
    "digits": "7012530000",
    "device_id": "599F9C00-92DC-4B5C-9464-7971F01F8370"
  }

  def create(conn, %{"registration" => registration_params}) do
    
  end
end
