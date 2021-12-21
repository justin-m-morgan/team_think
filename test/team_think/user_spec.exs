defmodule TeamThink.UserSpec do
  use TeamThink.DataCase, async: true
  use ExUnitProperties

  alias TeamThink.Accounts.User

  @max_email_length 160
  @min_password_length 8
  @max_password_length 72

  describe "registration changeset" do
    test "should accept a valid email and password" do
      check all(
              password <- password_generator(),
              email <- email_generator()
            ) do
        user = %User{}
        attrs = %{email: email, password: password}
        changeset = User.registration_changeset(user, attrs)

        assert changeset.valid?
      end
    end

    test "should reject a password that is too short" do
      check all(
              password <- password_generator(min_length: 0, max_length: @min_password_length - 1),
              email <- email_generator()
            ) do
        user = %User{}
        attrs = %{email: email, password: password}
        changeset = User.registration_changeset(user, attrs)

        refute changeset.valid?
      end
    end

    test "should reject a password that is too long" do
      check all(
              password <- password_generator(min_length: @max_password_length + 1),
              email <- email_generator()
            ) do
        user = %User{}
        attrs = %{email: email, password: password}
        changeset = User.registration_changeset(user, attrs)

        refute changeset.valid?
      end
    end

    test "should hash the submitted password" do
      check all(
              password <- password_generator(),
              email <- email_generator()
            ) do
        user = %User{}
        attrs = %{email: email, password: password}
        changeset = User.registration_changeset(user, attrs)
        hashed_password = changeset.changes.hashed_password

        assert Bcrypt.verify_pass(password, hashed_password)
      end
    end
  end

  describe "email changeset" do
    test "should accept a valid email" do
      check all(email <- email_generator()) do
        user = %User{}
        attrs = %{email: email}
        changeset = User.email_changeset(user, attrs)

        assert changeset.valid?
      end
    end

    test "should reject accept an invalid email and password" do
      check all(email <- invalid_email_generator()) do
        user = %User{}
        attrs = %{email: email}
        changeset = User.email_changeset(user, attrs)

        refute changeset.valid?
      end
    end
  end

  defp email_generator() do
    {string(:alphanumeric, min_length: 1), string(:alphanumeric, min_length: 1)}
    |> map(fn {left, right} -> left <> "@" <> right end)
    |> filter(&(String.length(&1) <= @max_email_length))
  end

  defp invalid_email_generator() do
    string(:alphanumeric)
    |> filter(&(not String.contains?(&1, "@")))
  end

  defp password_generator(opts \\ []) do
    min_length = opts[:min_length] || @min_password_length
    max_length = opts[:max_length] || @max_password_length
    string(:alphanumeric, min_length: min_length, max_length: max_length)
  end
end
