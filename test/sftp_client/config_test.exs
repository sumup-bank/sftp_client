defmodule SFTPClient.ConfigTest do
  use ExUnit.Case, async: true

  alias SFTPClient.Config

  describe "new/1" do
    setup do
      {:ok,
       data: %{
         host: "test-host",
         port: 23,
         user: "test-user",
         password: "test-password",
         user_dir: "~/.ssh",
         system_dir: "/etc/ssh",
         private_key_path: "~/key",
         private_key_pass_phrase: "t3$t",
         inet: :inet,
         sftp_vsn: 2,
         connect_timeout: 1000,
         dsa_pass_phrase: "dsa_t3$t",
         rsa_pass_phrase: "rsa_t3$t",
         ecdsa_pass_phrase: "ecdsa_t3$t"
       }}
    end

    test "defaults" do
      config = Config.new([])

      assert config.host == nil
      assert config.port == 22
      assert config.user == nil
      assert config.password == nil
      assert config.user_dir == nil
      assert config.system_dir == nil
      assert config.private_key_path == nil
      assert config.private_key_pass_phrase == nil
      assert config.inet == :inet
      assert config.sftp_vsn == nil
      assert config.connect_timeout == 5000
      assert config.dsa_pass_phrase == nil
      assert config.rsa_pass_phrase == nil
      assert config.ecdsa_pass_phrase == nil
    end

    test "build config with keyword list", %{data: data} do
      config = data |> Keyword.new() |> Config.new()

      Enum.each(data, fn {key, value} ->
        assert Map.fetch!(config, key) == value
      end)
    end

    test "build config with map", %{data: data} do
      config = Config.new(data)

      Enum.each(data, fn {key, value} ->
        assert Map.fetch!(config, key) == value
      end)
    end

    test "build config with SFTPClient.Config", %{data: data} do
      config = struct(Config, data)

      assert Config.new(config) == config
    end
  end
end
