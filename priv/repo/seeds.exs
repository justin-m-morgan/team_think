# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TeamThink.Repo.insert!(%TeamThink.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

user =
  TeamThink.Factory.insert(:valid_user, %{
    email: "justin@justin.com",
    password: "passwordpassword"
  })

projects = TeamThink.Factory.insert_list(3, :project, user: user)

task_lists =
  Enum.map(projects, fn project ->
    TeamThink.Factory.insert_list(3, :task_list, project: project)
  end)

# tasks = Enum.map(task_lists, fn task_list -> TeamThink.Factory.insert_list(4, :task, task_list: task_list) end)
