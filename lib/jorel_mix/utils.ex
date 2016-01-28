defmodule JorelMix.Utils do
  @jorel_app "./.jorel/jorel"
  @jorel_dir Path.dirname(@jorel_app)
  @jorel_url 'https://github.com/emedia-project/jorel/wiki/jorel'
  @jorel_config 'jorel.config'

  def jorel(params \\ []) do
    if not File.exists?(@jorel_app) do
      Mix.Shell.IO.info("Download jorel")
      :ssl.start()
      :inets.start()
      case :httpc.request(:get, {@jorel_url, []}, [autoredirect: true], []) do
        {:ok, {{_, 200, _}, _, body}} ->
          if not File.exists?(@jorel_dir), do: File.mkdir_p!(@jorel_dir)
          File.write!(@jorel_app, body)
          File.chmod!(@jorel_app, 0o755)
        _ ->
          Kernel.exit("Faild to download Jorel!")
      end
    end
    System.cmd(Path.expand(@jorel_app), params, stderr_to_stdout: true, into: IO.stream(:stdio, :line))
  end

  def build_config() do
    mixfile = Mix.Project.get!
    version = Mix.Project.config[:version] |> String.to_char_list
    app = Mix.Project.config[:app]
    applications = get_project_apps(mixfile)
    boot = [:elixir|applications] ++ [app, :sasl]

    base_config = get_jorel_config(mixfile, boot)
    {:exclude_dirs, exclude} = List.keyfind(base_config, :exclude_dirs, 0, ['**/_jorel/**'])
    deps = all_apps(exclude)
    conf = [{:release, {app, version}, deps}] ++ base_config
    :file.write_file(@jorel_config, "", [:write])
    Enum.each(conf, fn(c) ->
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
    all_deps: false,
    boot: boot,
    all_deps: false,
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
