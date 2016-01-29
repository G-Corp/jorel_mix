defmodule Mix.Tasks.Jorel.Tar do
  use Mix.Task

  @shortdoc "Create a Tar archive with your release"

  def run(argv) do
    JorelMix.Utils.jorel(argv, ["tar"])
  end
end
