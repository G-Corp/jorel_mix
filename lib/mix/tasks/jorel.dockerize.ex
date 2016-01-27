defmodule Mix.Tasks.Jorel.Dockerize do
  use Mix.Task

  @shortdoc "Create a Docker image with your release"

  def run(_) do
    {:ok, _} = Application.ensure_all_started(:jorel)
    :jorel.run([{:config, 'jorel.config'}, {:output_dir, './_jorel'}], [:dockerize])
  end
end
