# Streamline

Streamline provides a custom pipeline operator `~>` for working with Elixir pipelines
that handle `{:ok, _}` and `{:error, _}` tuples seamlessly.

This library enables clean and readable pipelines by:
- Passing values from `{:ok, value}` to the next function in the pipeline.
- Propagating `{:error, reason}` tuples without further processing.
- Wrapping plain values in `{:ok, _}` to maintain consistency.

## Motivation

In Elixir, it's common to handle `{:ok, _}` and `{:error, _}` tuples using the `with` construct.
While powerful, `with` can become verbose and less readable for sequential operations. For example:
```elixir
with {:ok, params} <- build_foo(params),
   {:ok, params} <- build_bar(params) do
  build_baz(params)
end
```

Streamline simplifies this pattern by allowing the same logic to be written as a clean and
readable pipeline:

```elixir
params
~> build_foo()
~> build_bar()
~> build_baz()
```

## Installation

```elixir
def deps do
[
  {:streamline, "~> 0.1"}
]
end
```

## Usage

Import `Streamline` to use the `~>` operator.

## Examples

```elixir
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
```

