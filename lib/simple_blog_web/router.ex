defmodule SimpleBlogWeb.Router do
  use SimpleBlogWeb, :router

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

  scope "/", SimpleBlogWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                              singleton: true
  end

  scope "/cms", SimpleBlogWeb.CMS, as: :cms do
    pipe_through [:browser, :authenticate_user]
    resources "/pages", PageController
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()  
      user_id ->
        assign(conn, :current_user, SimpleBlog.Accounts.get_user!(user_id))
    end
  end
end
