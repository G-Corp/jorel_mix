defmodule Mix.Tasks.Jorel.Zip do
  use Mix.Task

  @shortdoc "Create a Zip archive with your release"

  def run(_) do
    {:ok, _} = Application.ensure_all_started(:jorel)
    :jorel.run([{:config, 'jorel.config'}, {:output_dir, './_jorel'}], [:zip])
  end
end
