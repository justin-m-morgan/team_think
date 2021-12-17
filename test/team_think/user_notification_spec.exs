defmodule TeamThink.UserNotificationSpec do
  @moduledoc false

  use TeamThink.DataCase, async: true

  import Swoosh.TestAssertions

  alias TeamThink.Accounts.UserNotifier
  alias TeamThink.Factory

  describe "deliver_confirmation_instructions/2" do
    test "should send 'Confirmation Instructions' email" do
      random_user = Factory.build(:valid_user)
      random_url = Faker.Internet.url()

      UserNotifier.deliver_confirmation_instructions(random_user, random_url)
      assert_email_sent(subject: "Confirmation instructions")
    end

    test "should send email containing user's email and follow link" do
      random_user = Factory.build(:valid_user) |> Map.from_struct()
      random_url = Faker.Internet.url()

      {:ok, result} = UserNotifier.deliver_confirmation_instructions(random_user, random_url)

      assert result.html_body =~ random_user.email
      assert result.html_body =~ random_url
      assert result.text_body =~ random_user.email
      assert result.text_body =~ random_url
    end
  end

  describe "delivery_reset_password_instructions/2" do
    test "should send 'Reset Password instructions' email" do
      random_user = Factory.build(:valid_user)
      random_url = Faker.Internet.url()

      UserNotifier.deliver_reset_password_instructions(random_user, random_url)
      assert_email_sent(subject: "Reset password instructions")
    end

    test "should send email containing user's email and follow link" do
      random_user = Factory.build(:valid_user) |> Map.from_struct()
      random_url = Faker.Internet.url()

      {:ok, result} = UserNotifier.deliver_reset_password_instructions(random_user, random_url)

      assert result.html_body =~ random_user.email
      assert result.html_body =~ random_url
      assert result.text_body =~ random_user.email
      assert result.text_body =~ random_url
    end
  end

  describe "delivery_update_email_instructions/2" do
    test "should send 'Update Email Instructions' email" do
      random_user = Factory.build(:valid_user)
      random_url = Faker.Internet.url()

      UserNotifier.deliver_update_email_instructions(random_user, random_url)
      assert_email_sent(subject: "Update email instructions")
    end

    test "should send email containing user's email and follow link" do
      random_user = Factory.build(:valid_user) |> Map.from_struct()
      random_url = Faker.Internet.url()

      {:ok, result} = UserNotifier.deliver_update_email_instructions(random_user, random_url)

      assert result.html_body =~ random_user.email
      assert result.html_body =~ random_url
      assert result.text_body =~ random_user.email
      assert result.text_body =~ random_url
    end
  end
end
