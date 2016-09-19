# Hackney Adapter for HTTPipe

This package is an adapter for [HTTPipe](https://github.com/DavidAntaramian/httpipe)
that provides basic functionality using Hackney.

## Installation

First, add the adapter to your `mix.exs` dependencies.

```elixir
def deps do
  [
    {:httpipe_adapters_hackney, "~> 0.9"},
    {:httpipe, "~> 0.9}
  ]
end
```

If you wish to use Hackney as your primary adapter, you should also set it
as such in your `config/config.exs` (or other relevant config file):

```elixir
config :httpipe, :adapter, HTTPipe.Adapters.Hackney
```

You can also choose to use the Hackney adapter on a per-connection basis:

```elixir
conn =
  HTTPipe.Conn.new()
  |> HTTPipe.Conn.put_adapter(HTTPipe.Adapters.Hackney)
```

## Adapter Options

Any adapter options you set will be passed directly to Hackney's `request/5`
method. For example, to use the default pool started by Hackney:

```elixir
conn =
  HTTPipe.Conn.new()
  |> HTTPipe.Conn.put_adapter_options([pool: :default])
```

## Copyright and License

Copyright (c) 2016 David Antaramian

Licensed under the [ISC License](LICENSE.md)

