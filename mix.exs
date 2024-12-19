defmodule Streamline.MixProject do
  use Mix.Project

  def project do
    [
      app: :streamline,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  defp description do
    "Streamline pipelines with the ~> operator for handling {:ok, _} and {:error, _} tuples."
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: :streamline,
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/torepettersen/streamline"},
      maintainers: ["Tore Pettersen"]
    ]
  end
end
