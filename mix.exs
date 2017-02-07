defmodule JorelMix.Mixfile do
  use Mix.Project

  def project do
    [app: :jorel_mix,
     version: "0.0.4",
     elixir: "~> 1.2",
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
  
  defp description do
    """
    Just anOther RELease assembler
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Grégoire Lejeune"],
      licenses: ["BSD 3.0"],
      links: %{"GitHub" => "https://github.com/emedia-project/jorel_mix",
        "Docs" => "http://jorel.in"}
    ]
  end

  def jorel do
    [
      ignore_deps: [],
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
