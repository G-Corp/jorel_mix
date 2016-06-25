defmodule Mix.Tasks.Jorel.Appup do
  use Mix.Task

  @shortdoc "Generate appup files"

  def run(argv) do
    JorelMix.Utils.jorel(argv, ["appup"])
  end
end
