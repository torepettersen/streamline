defmodule Streamline do
  @moduledoc """
  Streamline provides a custom pipeline operator `~>` for working with Elixir pipelines
  that handle `{:ok, _}` and `{:error, _}` tuples seamlessly.

  This library enables clean and readable pipelines by:
  - Passing values from `{:ok, value}` to the next function in the pipeline.
  - Propagating `{:error, reason}` tuples without further processing.
  - Wrapping plain values in `{:ok, _}` to maintain consistency.

  ## Motivation

  In Elixir, it's common to handle `{:ok, _}` and `{:error, _}` tuples using the `with` construct.
  While powerful, `with` can become verbose and less readable for sequential operations. For example:

      with {:ok, params} <- build_foo(params),
           {:ok, params} <- build_bar(params) do
        build_baz(params)
      end

  Streamline simplifies this pattern by allowing the same logic to be written as a clean and
  readable pipeline:

      params
      ~> build_foo()
      ~> build_bar()
      ~> build_baz()

  ## Installation

      def deps do
        [
          {:streamline, "~> 0.1"}
        ]
      end

  ## Usage

  Import `Streamline` to use the `~>` operator.

  ## Examples

      iex> import Streamline

      # A successful pipeline
      iex> {:ok, 5}
      ...> ~> then(fn x -> {:ok, x * 2} end)
      ...> ~> then(fn x -> x + 3 end)
      {:ok, 13}

      # Stopping on an error
      iex> {:ok, 5}
      ...> ~> then(fn _ -> {:error, "failure"} end)
      ...> ~> then(fn x -> {:ok, x * 2} end)
      {:error, "failure"}

      # Wrapping a plain value
      iex> 5
      ...> ~> then(fn x -> x * 2 end)
      {:ok, 10}
  """

  @doc """
  Custom pipeline operator for handling `{:ok, _}` and `{:error, _}` tuples.

  Passes the result of one computation to the next in a pipeline,
  propagating errors or wrapping plain values as needed.
  """
  defmacro left ~> right do
    quote do
      unquote(left)
      |> then(fn
        {:ok, result} -> result |> unquote(right)
        {:error, _} = error -> error
        result -> result |> unquote(right)
      end)
      |> then(fn
        {:ok, _} = result -> result
        {:error, _} = error -> error
        result -> {:ok, result}
      end)
    end
  end
end
