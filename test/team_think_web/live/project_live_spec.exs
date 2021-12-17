defmodule TeamThinkWeb.ProjectLiveTest do
  use TeamThinkWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias TeamThink.Factory

  @projects_container_tag ~s/[data-test="projects-container"]/
  @project_details_tag ~s/[data-test="project-details"]/

  defp create_project(%{user: user}) do
    %{project: Factory.insert(:project, user: user)}
  end


  describe "Index LiveView" do
    setup [:register_and_log_in_user]


      test "should render a placeholder message when no projects assigned to user", %{conn: conn} do
        empty_placeholder_tag = "no-projects-placeholder"
        {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :index))

        index_live
        |> element(@projects_container_tag)
        |> render()
        |> then(fn html ->
            assert html =~ empty_placeholder_tag
        end)
      end

      test "should render an item for each project", %{conn: conn, user: user} do
        generated_count = 5
        Factory.insert_list(generated_count, :project, user: user)
        {:ok, _index_live, html} = live(conn, Routes.project_index_path(conn, :index))

        html
        |> Floki.parse_document!()
        |> Floki.find(@project_details_tag)
        |> then(fn elements ->
            assert length(elements) == generated_count
        end)
      end

      test "should be able to navigate to the project show page", %{conn: conn, user: user} do
        project = Factory.insert(:project, user: user)
        {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :index))

        index_live
        |> element("#project-#{project.id} a", "Show")
        |> render_click()

        assert_redirect(index_live, Routes.project_show_path(conn, :show, project))
      end

      test "should be able to edit the project in a modal", %{conn: conn, user: user} do
        project = Factory.insert(:project, user: user)
        {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :index))

        index_live
        |> element("#project-#{project.id} a", "Edit")
        |> render_click()

        assert_patch(index_live, Routes.project_show_path(conn, :edit, project))
      end

      test "should be able to delete the project", %{conn: conn, user: user} do
        project = Factory.insert(:project, user: user)
        {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :index))

        index_live
        |> element("#project-#{project.id} a", "Delete")
        |> render_click()
        |> then(fn html -> refute html =~ ~s/id="project-#{project.id}"/ end)
      end

      # TODO: Diagnose why breadcrumb component makes test crash
      #
      # test "should be able to create a new project in a modal", %{conn: conn, user: user} do
      #   new_params = Factory.build(:project_params) |> Map.delete(:user_id)
      #   {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :index))

      #   assert index_live
      #     |> element("a", "Create")
      #     |> render_click()
      #     |> then(fn _ -> index_live end)
      #     |> form("#project-form", project: new_params)
      #     |> render_submit(%{"user_id" => user.id})
      #     |> follow_redirect(conn, Routes.project_index_path(conn, :index))
      #     |> then(fn {:ok, _view, html} -> html end)
      #     |> then(fn html ->
      #       assert html =~ new_params.name
      #       assert html =~ new_params.description
      #     end)
      # end
  end

  describe "Show LiveView" do
    setup [:register_and_log_in_user, :create_project]

    test "should render the project's name and description", %{conn: conn, project: project}  do
      {:ok, show_live, _html} = live(conn, Routes.project_show_path(conn, :show, project))

      show_live
      |> element(@project_details_tag)
      |> render()
      |> then(fn html ->
          assert html =~ project.name
          assert html =~ project.description
      end)
    end

    test "should be able to open a modal to edit the project details", %{conn: conn, project: project} do
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

    test "should not be able to update the project details with invalid data", %{conn: conn, project: project} do

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

    test "should be able to navigate to the project's task_lists page", %{conn: conn, project: project} do
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
