defmodule TeamThinkWeb.ProjectLiveTest do
  use TeamThinkWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import TeamThink.TestingUtilities, only: [create_project: 1, create_many_projects: 1]

  alias TeamThink.Factory
  alias TeamThink.Teams

  # @projects_container_tag ~s/[data-test="projects-container"]/
  @project_details_tag ~s/[data-test="project-details"]/

  describe "Empty Index LiveView" do
    setup [:register_and_log_in_user]

    test "should render a placeholder message when no projects assigned to user", %{conn: conn} do
      empty_placeholder_tag = "no-projects-placeholder"
      {:ok, _index_live, html} = live(conn, Routes.project_index_path(conn, :index))

      assert html =~ empty_placeholder_tag
    end
  end

  describe "Index LiveView" do
    setup [:register_and_log_in_user, :create_many_projects]

    test "should render an item for each project", %{conn: conn} do
      # arbitrary, per hardcoded value in helper
      generated_count = 3

      {:ok, _index_live, html} = live(conn, Routes.project_index_path(conn, :index))

      html
      |> Floki.parse_document!()
      |> Floki.find(@project_details_tag)
      |> then(fn elements ->
        assert length(elements) == generated_count
      end)
    end

    test "should be able to navigate to the project show page", %{conn: conn, projects: projects} do
      project = List.first(projects)
      {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :index))

      index_live
      |> element("#project-#{project.id} a", "Show")
      |> render_click()

      assert_redirect(index_live, Routes.project_show_path(conn, :show, project))
    end

    test "should be able to edit the project in a modal", %{conn: conn, user: user} do
      %{project: project} = create_project(%{user: user})
      {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :index))

      index_live
      |> element("#project-#{project.id} a", "Edit")
      |> render_click()

      assert_patch(index_live, Routes.project_show_path(conn, :edit, project))
    end

    test "should be able to delete the project", %{conn: conn, projects: projects} do
      project = List.first(projects)
      {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :index))

      index_live
      |> element("#project-#{project.id} a", "Delete")
      |> render_click()
      |> then(fn html -> refute html =~ ~s/id="project-#{project.id}"/ end)
    end

    test "should be able to create a new project in a modal", %{conn: conn, user: user} do
      new_params = Factory.build(:project_params) |> Map.delete(:user_id)
      {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :new))

      assert index_live
             |> form("#project-form", project: new_params)
             |> render_submit(%{"user_id" => user.id})
             |> follow_redirect(conn, Routes.project_index_path(conn, :index))
             |> then(fn {:ok, _view, html} -> html end)
             |> then(fn html ->
               assert html =~ new_params.name
               assert html =~ new_params.description
             end)
    end

    test "should result in creating a team associated to the project", %{conn: conn, user: user} do
      new_params = Factory.build(:project_params) |> Map.delete(:user_id)
      {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :new))

      project_id =
        index_live
        |> form("#project-form", project: new_params)
        |> render_submit(%{"user_id" => user.id})
        |> follow_redirect(conn)
        |> then(&elem(&1, 2))
        |> get_project_id_from_index()

      assert Teams.get_team_by_project_id!(project_id)
    end
  end

  defp get_project_id_from_index(html) do
    html
    |> Floki.parse_document!()
    |> Floki.find(~s/[data-test="project-details"]/)
    |> Floki.attribute("id")
    |> List.first()
    |> String.split("-")
    |> List.last()
  end

  describe "Show LiveView" do
    setup [:register_and_log_in_user, :create_project]

    test "should render the project's name and description", %{conn: conn, project: project} do
      {:ok, show_live, _html} = live(conn, Routes.project_show_path(conn, :show, project))

      show_live
      |> element(@project_details_tag)
      |> render()
      |> then(fn html ->
        assert html =~ project.name
        assert html =~ project.description
      end)
    end

    test "should be able to open a modal to edit the project details", %{
      conn: conn,
      project: project
    } do
      {:ok, show_live, _html} = live(conn, Routes.project_show_path(conn, :show, project))

      assert show_live
             |> element(~s/a[aria-label="Edit"]/)
             |> render_click()
             |> then(fn html -> html =~ "Edit Project" end)

      assert_patch(show_live, Routes.project_show_path(conn, :edit, project))
    end

    test "should be able to update the project details with data", %{conn: conn, project: project} do
      update_params = Factory.build(:project_params) |> Map.delete(:user_id)
      {:ok, show_live, _html} = live(conn, Routes.project_show_path(conn, :edit, project))

      assert show_live
             |> form("#project-form", project: update_params)
             |> render_submit()
             |> follow_redirect(conn, Routes.project_show_path(conn, :show, project))
             |> then(fn {:ok, view, _} -> view end)
             |> element(@project_details_tag)
             |> render()
             |> then(fn html ->
               assert html =~ update_params.name
               assert html =~ update_params.description
             end)
    end

    test "should not be able to update the project details with invalid data", %{
      conn: conn,
      project: project
    } do
      invalid_update_params = Factory.build(:invalid_project_params) |> Map.delete(:user_id)
      {:ok, show_live, _html} = live(conn, Routes.project_show_path(conn, :edit, project))

      assert show_live
             |> form("#project-form", project: invalid_update_params)
             |> render_change()
             |> then(fn html -> html =~ "can&#39;t be blank" end)
    end

    # test "should be able to navigate to the project's team page", %{conn: conn, project: project} do
    #   {:ok, show_live, _html} = live(conn, Routes.project_show_path(conn, :show, project))
    #   teams_path = Routes.team_show_path(conn, :show, project)

    #   assert show_live
    #   |> element(~s/a[href="#{teams_path}"/)
    #   |> render_click()
    #   |> follow_redirect(conn, teams_path)
    # end

    test "should be able to navigate to the project's task_lists page", %{
      conn: conn,
      project: project
    } do
      {:ok, show_live, _html} = live(conn, Routes.project_show_path(conn, :show, project))
      task_lists_path = Routes.task_list_index_path(conn, :index, project)

      assert show_live
             |> element(~s/a[href="#{task_lists_path}"/)
             |> render_click()
             |> follow_redirect(conn, task_lists_path)
    end

    # test "should be able to navigate to the project's conversation page", %{conn: conn, project: project} do
    #   {:ok, show_live, _html} = live(conn, Routes.project_show_path(conn, :show, project))
    #   teams_path = Routes.conversation_show_path(conn, :show, project)

    #   assert show_live
    #   |> element(~s/a[href="#{teams_path}"/)
    #   |> render_click()
    #   |> follow_redirect(conn, teams_path)
    # end
  end
end
