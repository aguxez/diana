defmodule AuthWeb.Router do
  use AuthWeb, :router
  use FacebookMessenger.Phoenix.Router

  facebook_routes "/messenger/webhook", AuthWeb.MessengerController

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AuthWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/authorize", AuthorizeController, :authorize
    get "/authenticate", AuthenticationController, :authenticate
  end

  # Other scopes may use custom stacks.
  # scope "/api", AuthWeb do
  #   pipe_through :api
  # end
end
