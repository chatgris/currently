[![Build Status](https://travis-ci.org/chatgris/currently.png?branch=master)](https://travis-ci.org/chatgris/currently)

# Currently

`currently` is a tool to display cards currently assigned to you on Trello.

## Dependencies

  * Elixir >= 0.14

## How to use it?

``` sh
git clone https://github.com/chatgris/currently.git
cd currently
mix deps.get
mix escriptize
./currently configure -k <key> -t <token>
./currently cards
```

You can create a Developer API key on https://trello.com/1/appKey/generate.
For the token, see
https://trello.com/docs/gettingstarted/index.html#getting-a-token-from-a-user.

## Copyright

MIT. See LICENSE for further details.
