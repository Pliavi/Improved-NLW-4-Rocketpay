defmodule Rocketpay.UsersTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{User, Users}

  describe "create user" do
    test "successfully create and returns a user" do
      params = %{
        name: "Vitor",
        password: "123456",
        username: "pliavi",
        age: 25,
        email: "vitor@vitor.com"
      }

      {:ok, %User{id: user_id}} = Users.create(params)
      user = Repo.get!(User, user_id)

      assert %User{
               id: ^user_id,
               name: "Vitor",
               username: "pliavi",
               age: 25,
               email: "vitor@vitor.com"
             } = user
    end

    test "fail by invalid params and return list of errors" do
      params = %{
        name: "Vitor",
        username: "pliavi",
        email: "vitor_vitor.com",
        age: 10,
        password: "123"
      }

      {:error, changeset} = Users.create(params)

      expected_errors = %{
        age: ["must be greater than or equal to 18"],
        email: ["has invalid format"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(changeset) == expected_errors
    end
  end

  test "successfully update a user" do
    create_params = %{
      name: "Vitor",
      password: "123456",
      username: "pliavi",
      age: 25,
      email: "vitor@vitor.com"
    }

    update_params = %{
      name: "fulano",
      password: "654321",
      username: "fulano",
      age: 24,
      email: "fulano@fulano.net"
    }

    {:ok, %User{id: user_id}} = Users.create(create_params)

    user = Repo.get!(User, user_id)
    {:ok, updated_user} = Users.update(user, update_params)

    assert %{
             name: "fulano",
             username: "fulano",
             age: 24,
             email: "fulano@fulano.net"
           } = updated_user

    assert user.password_hash != updated_user.password_hash
  end

  test "successfully delete a user" do
    create_params = %{
      name: "Vitor",
      password: "123456",
      username: "pliavi",
      age: 25,
      email: "vitor@vitor.com"
    }

    {:ok, %User{id: user_id}} = Users.create(create_params)
    user = Repo.get!(User, user_id)

    assert {:ok, _} = Users.delete(user)
  end
end
