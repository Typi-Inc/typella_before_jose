defmodule Auth.Router do
  use Auth.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Auth do
    pipe_through :api

    post "/register", RegistrationController, :create
    # post "/verify", AccountController, :create
  end
end
