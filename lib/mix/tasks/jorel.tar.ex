defmodule Mix.Tasks.Jorel.Tar do
  use Mix.Task

  @shortdoc "Create a Tar archive with your release"

  def run(argv) do
    Mix.Task.run("jorel.gen_config", argv)
    JorelMix.Utils.jorel(["tar"])
  end
end
