defmodule Mix.Tasks.Jorel.Dockerize do
  use Mix.Task

  @shortdoc "Create a Docker image with your release"

  def run(argv) do
    Mix.Task.run("jorel.gen_config", argv)
    JorelMix.Utils.jorel(["dockerize"])
  end
end
