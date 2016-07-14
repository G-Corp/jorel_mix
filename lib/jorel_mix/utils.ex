defmodule JorelMix.Utils do
  @jorel_app Path.expand("~/.jorel/jorel")
  @jorel_app_master Path.expand("~/.jorel/jorel.master")
  @jorel_url 'https://github.com/emedia-project/jorel/wiki/jorel'
  @jorel_md5_url 'https://github.com/emedia-project/jorel/wiki/jorel.md5'
  @jorel_master_url 'https://github.com/emedia-project/jorel/wiki/jorel.master'
  @jorel_master_md5_url 'https://github.com/emedia-project/jorel/wiki/jorel.master.md5'
  @jorel_config 'jorel.config'

  def jorel(argv, params \\ []) do
    {args, _, _} = OptionParser.parse(argv)
    {jorel_url, jorel_md5_url, jorel_app} = if args[:master] == true do
      {@jorel_master_url, @jorel_master_md5_url, @jorel_app_master}
    else
      {@jorel_url, @jorel_md5_url, @jorel_app}
    end
    jorel_dir = Path.dirname(jorel_app)
    Mix.Shell.IO.info "Use #{jorel_app}"
    if not File.exists?(jorel_app) or args[:upgrade] do
      :ssl.start()
      :inets.start()
      unless check(jorel_app, jorel_md5_url) do
        case :httpc.request(:get, {jorel_url, []}, [autoredirect: true], []) do
          {:ok, {{_, 200, _}, _, body}} ->
            Mix.Shell.IO.info("Upgrade #{jorel_app}")
            if not File.exists?(jorel_dir), do: File.mkdir_p!(jorel_dir)
            File.write!(jorel_app, body)
            File.chmod!(jorel_app, 0o755)
          _ ->
            Kernel.exit("Failed to download Jorel!")
        end
      else
        Mix.Shell.IO.info("#{jorel_app} is up to date.")
      end
    end
    keep_config = File.exists?(@jorel_config)
    if keep_config == false or args[:force] == true do
      build_config(argv)
    else
      Mix.Shell.IO.info "#{@jorel_config} exist, use it. (use --force to override)"
    end
    System.cmd(Path.expand(jorel_app), params, stderr_to_stdout: true, into: IO.stream(:stdio, :line))
    unless keep_config do
      File.rm!(@jorel_config) 
    end
  end

  defp check(jorel_app, jorel_md5_url) do
    :crypto.start()
    if File.exists?(jorel_app) do
      case :file.read_file(jorel_app) do
        {:ok, data} ->
          case :httpc.request(:get, {jorel_md5_url, []}, [autoredirect: true], []) do
            {:ok, {{_, 200, _}, _, md5}} ->
              (:crypto.hash(:md5, data) 
               |> Base.encode16 
               |> String.downcase) == String.strip(List.to_string(md5)) 
            _ ->
              false
          end
        _ ->
          false
      end
    else
      false
    end
  end

  def build_config(argv) do
    Mix.Shell.IO.info "Generate #{@jorel_config}"
    Mix.Project.compile(argv)
    mixfile = Mix.Project.get!
    version = Mix.Project.config[:version] |> String.to_char_list
    app = Mix.Project.config[:app]
    applications = get_project_apps(mixfile)
    boot = [:elixir|applications] ++ [app, :sasl]

    jorel_config = get_jorel_config(mixfile, boot)
    {:exclude_dirs, exclude} = List.keyfind(jorel_config, :exclude_dirs, 0, ['**/_jorel/**'])

    jorel_config = case List.keyfind(jorel_config, :boot, 0) do
      {:boot, _} -> jorel_config
      _ -> [{:boot, boot}|jorel_config]
    end

    jorel_config = case List.keyfind(jorel_config, :release, 0) do
      {:release, _, _} -> jorel_config
      _ -> [{:release, {app, version}, [:elixir|all_apps(exclude)]}|jorel_config]
    end

    :file.write_file(@jorel_config, "", [:write])
    Enum.each(jorel_config, fn(c) ->
      :file.write_file(@jorel_config, :io_lib.fwrite('~p.~n', [c]), [:append])
    end)
  end

  defp get_project_apps(mixfile) when is_atom(mixfile) do
    exports = mixfile.module_info(:exports)
    cond do
      {:application, 0} in exports ->
        app_spec = mixfile.application
        Keyword.get(app_spec, :applications, []) ++ Keyword.get(app_spec, :included_applications, [])
      :else ->
        []
    end
  end

  defp get_jorel_config(mixfile, boot) when is_atom(mixfile) do
    exports = mixfile.module_info(:exports)
    cond do
      {:jorel, 0} in exports ->
        mixfile.jorel
      :else ->
        jorel_config_default(boot)
    end
  end

  defp jorel_config_default(boot), do: [
    ignore_deps: [:jorel_mix],
    boot: boot,
    all_deps: false,
    sys_config: 'config/config.exs',
    output_dir: '_jorel',
    exclude_dirs: ['**/_jorel/**', '**/_rel*/**', '**/test/**'],
    include_src: false,
    include_erts: true,
    disable_relup: false,
    providers: [:jorel_provider_tar, :jorel_provider_zip, :jorel_provider_deb, :jorel_provider_config]
  ]

  defp all_apps(exclude) do
    wildcard("**/ebin/*.app", exclude, [:expand_path])
    |> List.foldl([:sasl], fn(app, acc) ->
      [String.to_atom(Path.basename(app, ".app"))|acc]
    end) 
    |> Enum.uniq
  end

  defp wildcard(path, exclude, options) do
    delete_if(Path.wildcard(path), fn(p) ->
      Enum.any?(exclude, fn(e) ->
        match(p, e, options)
      end)
    end)
  end

  defp delete_if(list, fun) do
    List.foldl(list, [], fn(e, acc) ->
      case fun.(e) do
        true -> acc;
        false -> [e|acc]
      end
    end) 
    |> Enum.reverse
  end

  def match(path, exp, options \\ []) do
    path = case List.keyfind(options, :cd, 0) do
      {:cd, cd} -> Path.join([cd, path])
      _ -> path
    end
    path = case Enum.member?(options, :expand_path) do
      true -> Path.expand(path)
      false -> path
    end
    exp = Kernel.to_string(exp)
    |> String.replace(".", "\\.",  global: true)
    |> String.replace("?", ".", global: true)
    |> String.replace("*", "[^/]*", global: true)
    |> String.replace("[^/]*[^/]*", ".*", global: true)
    {exp, _} = "^" <> exp <> "$"
    |> String.to_char_list
    |> List.foldl({'', :none}, fn
      (?{, {acc, :none}) ->
          {[?(|acc], :in}
      (?}, {acc, :in}) ->
          {[?)|acc], :none}
      (?,, {acc, :in}) ->
          {[?||acc], :in}
      (32, {acc, :in}) ->
          {acc, :in}
      (c, {acc, t}) ->
          {[c|acc], t}
    end)
    {:ok, exp} = Enum.reverse(exp) |> List.to_string |> Regex.compile
    Regex.match?(exp, Kernel.to_string(path)) 
  end
end
