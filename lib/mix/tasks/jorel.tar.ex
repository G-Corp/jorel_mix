defmodule Mix.Tasks.Jorel.Tar do
  use Mix.Task

  @shortdoc "Create a Tar archive with your release"

  def run(_) do
    {:ok, _} = Application.ensure_all_started(:jorel)
    :jorel.run([{:config, 'jorel.config'}, {:output_dir, './_jorel'}], [:tar])
  end
end
