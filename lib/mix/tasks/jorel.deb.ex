defmodule Mix.Tasks.Jorel.Deb do
  use Mix.Task

  @shortdoc "Create a Debian package with your release"

  def run(argv) do
    JorelMix.Utils.jorel(argv, ["deb"])
  end
end
