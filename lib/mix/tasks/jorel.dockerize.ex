defmodule Mix.Tasks.Jorel.Dockerize do
  use Mix.Task

  @shortdoc "Create a Docker image with your release"

  def run(argv) do
    JorelMix.Utils.jorel(argv, ["dockerize"])
  end
end
