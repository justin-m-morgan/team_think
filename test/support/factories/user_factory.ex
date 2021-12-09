defmodule TeamThink.Factory.UserFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias TeamThink.Accounts.User

      @min_password_length 12
      @max_password_length 72

      def valid_user_factory do
        password = password_generator()

        %User{
          email: Faker.Internet.email(),
          password: password,
          hashed_password: Bcrypt.hash_pwd_salt(password)
        }
      end

      def invalid_user_factory do
        password = invalid_password_generator()

        %User{
          email: invalid_email_generator(),
          password: password,
          hashed_password: Bcrypt.hash_pwd_salt(password)
        }
      end

      def valid_email_generator() do
        Faker.Internet.email()
      end

      def invalid_email_generator() do
        Faker.Lorem.words() |> Enum.join()
      end

      def password_generator(
            min_length \\ @min_password_length,
            max_length \\ @max_password_length
          ) do
        Faker.random_between(min_length, max_length)
        |> Faker.random_bytes()
      end

      def invalid_password_generator() do
        [
          password_generator(1, @min_password_length - 1),
          password_generator(@max_password_length + 1, 256)
        ]
        |> Enum.random()
      end
    end
  end
end
