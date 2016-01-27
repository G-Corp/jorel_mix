defmodule Mix.Tasks.Jorel.Deb do
  use Mix.Task

  @shortdoc "Create a Debian package with your release"

  def run(_) do
    {:ok, _} = Application.ensure_all_started(:jorel)
    :jorel.run([{:config, 'jorel.config'}, {:output_dir, './_jorel'}], [:deb])
  end
end
