defmodule TeamThinkWeb.TaskLiveTest do
  use TeamThinkWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import TeamThink.TestingUtilities, only: [create_project: 1]

  alias TeamThink.Factory

  @tasks_container_tag ~s/[data-test="tasks-container"]/
  @task_details_tag ~s/[data-test="task-details"]/

  defp create_task_list(%{project: project}) do
    %{task_list: Factory.insert(:task_list, project: project, tasks: [])}
  end
  defp create_task(%{task_list: task_list}) do
    %{task: Factory.insert(:task, task_list: task_list)}
  end

  describe "Index LiveView" do
    setup [:register_and_log_in_user, :create_project, :create_task_list]

      test "should render a placeholder message when no task_lists assigned to project",
        %{
          conn: conn,
          project: project,
          task_list: task_list
        } do

        empty_placeholder_tag = "no-tasks-placeholder"
        {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index, project, task_list))

        index_live
        |> element(@tasks_container_tag)
        |> render()
        |> then(fn html ->
            assert html =~ empty_placeholder_tag
        end)
      end

      test "should render an item for each task", %{conn: conn, project: project, task_list: task_list} do
        generated_count = 5
        Factory.insert_list(generated_count, :task, task_list: task_list)
        {:ok, _index_live, html} = live(conn, Routes.task_index_path(conn, :index, project, task_list))

        html
        |> Floki.parse_document!()
        |> Floki.find(@task_details_tag)
        |> then(fn elements ->
            assert length(elements) == generated_count
        end)
      end

      test "should be able to navigate to the task show page", %{conn: conn, project: project, task_list: task_list} do
        task = Factory.insert(:task, task_list: task_list)
        {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index, project, task_list))

        index_live
        |> element("#task-#{task.id} a", "Show")
        |> render_click()

        assert_redirect(index_live, Routes.task_show_path(conn, :show, project, task_list, task))
      end

      test "should be able to open the edit modal", %{conn: conn, project: project, task_list: task_list} do
        task = Factory.insert(:task, task_list: task_list)
        {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index, project, task_list))

        index_live
        |> element("#task-#{task.id} a", "Edit")
        |> render_click()

        assert_patch(index_live, Routes.task_show_path(conn, :edit, project, task_list, task))
      end

      test "should be able to delete the task", %{conn: conn, project: project, task_list: task_list} do
        task = Factory.insert(:task, task_list: task_list)
        {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index, project, task_list))

        index_live
        |> element("#task-#{task.id} a", "Delete")
        |> render_click()
        |> then(fn html -> refute html =~ ~s/id="task-#{task.id}"/ end)
      end

      test "should be able to create a new task in a modal",
        %{conn: conn, project: project, task_list: task_list} do

        new_params = Factory.build(:task_params) |> Map.delete(:task_list_id) |> Map.delete(:status)

        {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :new, project, task_list))

        assert index_live
          |> form("#task-form", task: new_params)
          |> render_submit(%{"task_list_id" => task_list.id, "status" => "outstanding"})
          |> follow_redirect(conn, Routes.task_index_path(conn, :index, project, task_list))
          |> then(fn {:ok, _view, html} -> html end)
          |> then(fn html ->
            assert html =~ new_params.name
            assert html =~ new_params.description
          end)
      end
  end


  describe "Show" do
    setup [:register_and_log_in_user, :create_project, :create_task_list, :create_task]

    test "should render the task's name and description",
      %{conn: conn, project: project, task_list: task_list, task: task} do

      {:ok, show_live, _html} = live(conn, Routes.task_show_path(conn, :show, project, task_list, task))

      show_live
      |> element(@task_details_tag)
      |> render()
      |> then(fn html ->
          assert html =~ task.name
          assert html =~ task.description
      end)
    end

    test "should be able to open a modal to edit the task details",
      %{conn: conn, project: project, task_list: task_list, task: task} do

      {:ok, show_live, _html} = live(conn, Routes.task_show_path(conn, :show, project, task_list, task))

      assert show_live
        |> element(~s/a[aria-label="Edit"]/)
        |> render_click()
        |> then(fn html -> html =~ "Edit Task" end)

      assert_patch(show_live, Routes.task_show_path(conn, :edit, project, task_list, task))
    end

    test "should be able to update the task details with valid data",
      %{conn: conn, project: project, task_list: task_list, task: task} do

      update_params = Factory.build(:task_params) |> Map.delete(:task_list_id) |> Map.delete(:status)

      {:ok, show_live, _html} = live(conn, Routes.task_show_path(conn, :edit, project, task_list, task))

      assert show_live
        |> form("#task-form", task: update_params)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_show_path(conn, :show, project, task_list, task))
        |> then(fn {:ok, view, _} -> view end)
        |> element(@task_details_tag)
        |> render()
        |> then(fn html ->
          assert html =~ update_params.name
          assert html =~ update_params.description
        end)
    end

    test "should not be able to update the task details with invalid data",
      %{conn: conn, project: project, task_list: task_list, task: task} do

      invalid_update_params = Factory.build(:invalid_task_params) |> Map.delete(:task_list_id) |> Map.delete(:status)
      {:ok, show_live, _html} = live(conn, Routes.task_show_path(conn, :edit, project, task_list, task))

      assert show_live
        |> form("#task-form", task: invalid_update_params)
        |> render_change()
        |> then(fn html -> html =~ "can&#39;t be blank" end)

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
