defmodule Mix.Tasks.Jorel.Release do
  use Mix.Task

  @shortdoc "Release your app"

  def run(argv) do
    JorelMix.Utils.jorel(argv, ["release"])
  end
end
