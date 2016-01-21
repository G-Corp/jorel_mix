defmodule Mix.Tasks.Jorel.Release do
  use Mix.Task

  def run(_) do
    {:ok, _} = Application.ensure_all_started(:jorel)
    :jorel.run([{:config, 'jorel.config'}, {:output_dir, './_jorel'}], [:release])
  end
end
