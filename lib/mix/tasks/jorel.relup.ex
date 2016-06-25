defmodule Mix.Tasks.Jorel.Relup do
  use Mix.Task

  @shortdoc "Create relup of release"

  def run(argv) do
    JorelMix.Utils.jorel(argv, ["relup"])
  end
end
