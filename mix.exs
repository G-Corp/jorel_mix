defmodule JorelMix.Mixfile do
  use Mix.Project

  def project do
    [app: :jorel_mix,
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
    []
  end

  def jorel do
    [
      ignore_deps: [],
      all_deps: false,
      boot: [:elixir, :jorel_mix, :sasl],
      all_deps: false,
      output_dir: '_jorel',
      exclude_dirs: ['**/_jorel/**', '**/_rel*/**', '**/test/**'],
      include_src: false,
      include_erts: true,
      disable_relup: false,
      providers: [:jorel_provider_tar, :jorel_provider_zip, :jorel_provider_deb, :jorel_provider_config]
    ]
  end
end
