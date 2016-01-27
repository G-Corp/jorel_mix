defmodule Mix.Tasks.Jorel.GenConfig do
  use Mix.Task

  @shortdoc "Create a default Jorel configuration"

  def run(_) do
    {:ok, _} = Application.ensure_all_started(:jorel)
    :jorel.run([{:config, 'jorel.config'}, {:output_dir, './_jorel'}], [:gen_config])
  end
end
