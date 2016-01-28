defmodule Mix.Tasks.Jorel.Deb do
  use Mix.Task

  @shortdoc "Create a Debian package with your release"

  def run(argv) do
    Mix.Task.run("jorel.gen_config", argv)
    JorelMix.Utils.jorel(["deb"])
  end
end
