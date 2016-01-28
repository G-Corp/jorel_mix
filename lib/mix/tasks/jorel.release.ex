defmodule Mix.Tasks.Jorel.Release do
  use Mix.Task

  @shortdoc "Release your app"

  def run(argv) do
    Mix.Task.run("jorel.gen_config", argv)
    JorelMix.Utils.jorel(["release"])
  end
end
