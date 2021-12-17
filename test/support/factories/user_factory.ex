defmodule TeamThink.Factory.UserFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias TeamThink.Accounts.User

      @min_password_length 12
      @max_password_length 72

      def valid_email_factory() do
        Faker.Internet.email()
      end

      def invalid_email_factory() do
        Faker.Lorem.words() |> Enum.join()
      end

      def password_factory(
            min_length \\ @min_password_length,
            max_length \\ @max_password_length
          ) do
        Faker.random_between(min_length, max_length)
        |> Faker.random_bytes()
      end

      def invalid_password_factory() do
        [
          password_factory(1, @min_password_length - 1),
          password_factory(@max_password_length + 1, 256)
        ]
        |> Enum.random()
      end

      def valid_user_params_factory() do
        %{
          email: valid_user_factory(),
          password: "passwordpassword"
        }
      end

      def valid_user_factory do
        %User{
          email: Faker.Internet.email(),
          password: "passwordpassword",
          hashed_password: Bcrypt.hash_pwd_salt("passwordpassword")
        }
      end

      def invalid_user_params_factory do
        password = invalid_password_factory()

        %{
          email: invalid_email_factory(),
          password: password,
          hashed_password: Bcrypt.hash_pwd_salt(password)
        }
      end
    end
  end
end
