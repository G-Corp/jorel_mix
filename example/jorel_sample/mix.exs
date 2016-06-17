defmodule JorelSample.Mixfile do
  use Mix.Project

  def project do
    [app: :jorel_sample,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:jorel_mix, git: "https://github.com/emedia-project/jorel_mix", branch: "master"},
    ]
  end

  def jorel do
    [
      ignore_deps: [:jorel_mix],
      all_deps: false,
      output_dir: '_jorel_custom',
      boot: [:jorel_sample, :sasl],
      exclude_dirs: ['**/_jorel/**', '**/_rel*/**', '**/test/**'],
      include_src: true,
      include_erts: true,
      sys_config: 'config/config.exs',
      disable_relup: false,
      init_sources: '/etc/environment',
      providers: [:jorel_provider_tar, :jorel_provider_zip, :jorel_provider_deb, :jorel_provider_config]
    ]
  end
end
