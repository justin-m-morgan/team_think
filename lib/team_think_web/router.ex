defmodule TeamThinkWeb.Router do
  use TeamThinkWeb, :router

  import TeamThinkWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TeamThinkWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TeamThinkWeb do
    pipe_through :browser
  end

  # Other scopes may use custom stacks.
  # scope "/api", TeamThinkWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/live_dashboard", metrics: TeamThinkWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", TeamThinkWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/", PageController, :index

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", TeamThinkWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live "/projects", ProjectLive.Index, :index
    live "/projects/new", ProjectLive.Index, :new

    live_session :team_mates, on_mount: {TeamThinkWeb.UserLiveAuth, :team_members} do
      live "/projects/:project_id", ProjectLive.Show, :show
      live "/projects/:project_id/show/edit", ProjectLive.Show, :edit

      live "/projects/:project_id/conversations", ConversationLive.Show, :show
      # live "/projects/:project_id/conversations/:id/show/edit", ConversationLive.Show, :edit

      live "/projects/:project_id/team/:team_id", TeamLive.Show, :show

      live "/projects/:project_id/task_lists", TaskListLive.Index, :index
      live "/projects/:project_id/task_lists/new", TaskListLive.Index, :new
      live "/projects/:project_id/task_lists/:list_id/edit", TaskListLive.Index, :edit
      live "/projects/:project_id/task_lists/:list_id", TaskListLive.Show, :show
      live "/projects/:project_id/task_lists/:list_id/show/edit", TaskListLive.Show, :edit

      live "/projects/:project_id/task_lists/:list_id/conversations", ConversationLive.Show, :show

      live "/projects/:project_id/task_lists/:list_id/tasks", TaskLive.Index, :index
      live "/projects/:project_id/task_lists/:list_id/tasks/new", TaskLive.Index, :new
      live "/projects/:project_id/task_lists/:list_id/tasks/:task_id/edit", TaskLive.Index, :edit

      live "/projects/:project_id/task_lists/:list_id/tasks/:task_id", TaskLive.Show, :show
      live "/projects/:project_id/task_lists/:list_id/tasks/:task_id/show/edit", TaskLive.Show, :edit

      live "/projects/:project_id/task_lists/:list_id/tasks/:task_id/conversations", ConversationLive.Show, :show
    end
  end




  scope "/", TeamThinkWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
