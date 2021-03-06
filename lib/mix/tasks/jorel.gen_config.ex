defmodule Mix.Tasks.Jorel.GenConfig do
  use Mix.Task
  @jorel_config "jorel.config"

  @shortdoc "Create a default Jorel configuration"

  def run(argv) do
    {args, _, _} = OptionParser.parse(argv)
    if args[:force] == true or File.exists?(@jorel_config) == false do
      JorelMix.Utils.build_config(argv)
    else
      Mix.shell.info "#{@jorel_config} already exist, use `--force' to override!"
    end
  end
end
