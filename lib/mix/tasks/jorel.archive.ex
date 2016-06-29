defmodule Mix.Tasks.Jorel.Archive do
  use Mix.Task

  @shortdoc "Create release archive"

  def run(argv) do
    JorelMix.Utils.jorel(argv, ["archive"])
  end
end
