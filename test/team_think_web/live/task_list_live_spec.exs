defmodule TeamThinkWeb.TaskListLiveTest do
  use TeamThinkWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import TeamThink.TestingUtilities, only: [create_project: 1]

  alias TeamThink.Factory

  @task_lists_container_tag ~s/[data-test="task_lists-container"]/
  @task_list_details_tag ~s/[data-test="task_list-details"]/

  describe "Index LiveView" do
    setup [:register_and_log_in_user, :create_project]

    test "should render a placeholder message when no task_lists assigned to project", %{
      conn: conn,
      project: project
    } do
      empty_placeholder_tag = "no-task_lists-placeholder"

      {:ok, index_live, _html} = live(conn, Routes.task_list_index_path(conn, :index, project))

      index_live
      |> element(@task_lists_container_tag)
      |> render()
      |> then(fn html ->
        assert html =~ empty_placeholder_tag
      end)
    end

    test "should render an item for each task_list", %{conn: conn, project: project} do
      generated_count = 5
      Factory.insert_list(generated_count, :task_list, project: project)
      {:ok, _index_live, html} = live(conn, Routes.task_list_index_path(conn, :index, project))

      html
      |> Floki.parse_document!()
      |> Floki.find(@task_list_details_tag)
      |> then(fn elements ->
        assert length(elements) == generated_count
      end)
    end

    test "should be able to navigate to the task_list show page", %{conn: conn, project: project} do
      task_list = Factory.insert(:task_list, project: project)
      {:ok, index_live, _html} = live(conn, Routes.task_list_index_path(conn, :index, project))

      index_live
      |> element("#task_list-#{task_list.id} a", "Show")
      |> render_click()

      assert_redirect(index_live, Routes.task_list_show_path(conn, :show, project, task_list))
    end

    test "should be able to edit the task_list in a modal", %{conn: conn, project: project} do
      task_list = Factory.insert(:task_list, project: project)
      {:ok, index_live, _html} = live(conn, Routes.task_list_index_path(conn, :index, project))

      index_live
      |> element("#task_list-#{task_list.id} a", "Edit")
      |> render_click()

      assert_patch(index_live, Routes.task_list_show_path(conn, :edit, project, task_list))
    end

    test "should be able to delete the project", %{conn: conn, project: project} do
      task_list = Factory.insert(:task_list, project: project)
      {:ok, index_live, _html} = live(conn, Routes.task_list_index_path(conn, :index, project))

      index_live
      |> element("#task_list-#{task_list.id} a", "Delete")
      |> render_click()
      |> then(fn html -> refute html =~ ~s/id="task_list-#{task_list.id}"/ end)
    end

    test "should be able to create a new task_list in a modal", %{conn: conn, project: project} do
      new_params = Factory.build(:task_list_params) |> Map.delete(:project_id)
      {:ok, index_live, _html} = live(conn, Routes.task_list_index_path(conn, :new, project))

      assert index_live
             |> form("#task_list-form", task_list: new_params)
             |> render_submit(%{"project_id" => project.id})
             |> follow_redirect(conn, Routes.task_list_index_path(conn, :index, project))
             |> then(fn {:ok, _view, html} -> html end)
             |> then(fn html ->
               assert html =~ new_params.name
               assert html =~ new_params.description
             end)
    end
  end

  defp create_task_list(%{project: project}) do
    task_list = Factory.insert(:task_list, project: project)
    %{task_list: task_list}
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_project, :create_task_list]

    test "should render the task_list's name and description", %{
      conn: conn,
      project: project,
      task_list: task_list
    } do
      {:ok, show_live, _html} =
        live(conn, Routes.task_list_show_path(conn, :show, project, task_list))

      show_live
      |> element(@task_list_details_tag)
      |> render()
      |> then(fn html ->
        assert html =~ task_list.name
        assert html =~ task_list.description
      end)
    end

    test "should be able to open a modal to edit the task_list details", %{
      conn: conn,
      project: project,
      task_list: task_list
    } do
      {:ok, show_live, _html} =
        live(conn, Routes.task_list_show_path(conn, :show, project, task_list))

      assert show_live
             |> element(~s/a[aria-label="Edit"]/)
             |> render_click()
             |> then(fn html -> html =~ "Edit Task List" end)

      assert_patch(show_live, Routes.task_list_show_path(conn, :edit, project, task_list))
    end

    test "should be able to update the project details with data", %{
      conn: conn,
      project: project,
      task_list: task_list
    } do
      update_params = Factory.build(:task_list_params) |> Map.delete(:project_id)

      {:ok, show_live, _html} =
        live(conn, Routes.task_list_show_path(conn, :edit, project, task_list))

      assert show_live
             |> form("#task_list-form", task_list: update_params)
             |> render_submit()
             |> follow_redirect(conn, Routes.task_list_show_path(conn, :show, project, task_list))
             |> then(fn {:ok, view, _} -> view end)
             |> element(@task_list_details_tag)
             |> render()
             |> then(fn html ->
               assert html =~ update_params.name
               assert html =~ update_params.description
             end)
    end

    test "should not be able to update the project details with invalid data", %{
      conn: conn,
      project: project,
      task_list: task_list
    } do
      invalid_update_params = Factory.build(:invalid_task_list_params) |> Map.delete(:project_id)

      {:ok, show_live, _html} =
        live(conn, Routes.task_list_show_path(conn, :edit, project, task_list))

      assert show_live
             |> form("#task_list-form", task_list: invalid_update_params)
             |> render_change()
             |> then(fn html -> html =~ "can&#39;t be blank" end)
    end

    test "should be able to navigate to the task_lists's tasks page", %{
      conn: conn,
      project: project,
      task_list: task_list
    } do
      {:ok, show_live, _html} =
        live(conn, Routes.task_list_show_path(conn, :show, project, task_list))

      tasks_path = Routes.task_index_path(conn, :index, project, task_list)

      assert show_live
             |> element(~s/a[href="#{tasks_path}"/)
             |> render_click()
             |> follow_redirect(conn, tasks_path)
    end

    # test "should be able to navigate to the project's conversation page", %{conn: conn, project: project, task_list: task_list} do
    #   {:ok, show_live, _html} = live(conn, Routes.project_show_path(conn, :show, project))
    #   teams_path = Routes.conversation_show_path(conn, :show, project)

    #   assert show_live
    #   |> element(~s/a[href="#{teams_path}"/)
    #   |> render_click()
    #   |> follow_redirect(conn, teams_path)
    # end
  end
end
