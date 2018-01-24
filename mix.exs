defmodule Diana.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:credo, "~> 0.8.10", only: [:dev, :test]},
      {:poison, "~> 3.1.0", override: true},
      {:facebook_messenger, github: "aguxez/facebook_messenger", override: true},
      {:earmark, "~> 1.1", override: true},
    ]
  end
end
