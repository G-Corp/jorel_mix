defmodule Mix.Tasks.Jorel.Zip do
  use Mix.Task

  @shortdoc "Create a Zip archive with your release"

  def run(argv) do
    Mix.Task.run("jorel.gen_config", argv)
    JorelMix.Utils.jorel(["tar"])
  end
end
