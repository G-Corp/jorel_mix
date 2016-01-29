defmodule Mix.Tasks.Jorel.Zip do
  use Mix.Task

  @shortdoc "Create a Zip archive with your release"

  def run(argv) do
    JorelMix.Utils.jorel(argv, ["tar"])
  end
end
