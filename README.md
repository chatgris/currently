[![Build Status](https://travis-ci.org/chatgris/currently.png?branch=master)](https://travis-ci.org/chatgris/currently)

# Currently

`currently` is a tool to display cards currently assigned to you on Trello.

## Dependencies

  * Elixir >= 0.10.1

## How to use it?

``` sh
mix deps.get
mix escriptize
./currently configure -k <key> -t <token>
./currently cards
```

You can create a Developer API key on https://trello.com/1/appKey/generate.
For the token, see
https://trello.com/docs/gettingstarted/index.html#getting-a-token-from-a-user.


## Notice

This build is builded while I'm reading [Programming Elixir: Functional |>
Concurrent |> Pragmatic |>
Fun](http://pragprog.com/book/elixir/programming-elixir), so this project is a
WIP.

## Copyright

MIT. See LICENSE for further details.
