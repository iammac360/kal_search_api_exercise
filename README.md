# Suppliers Search API

## Description
Simple Suppliers Search API built with Elixir Plug(For handling http requests), Cachex(For caching) and Cowboy(Web Server).

## Requirements

* erlang 20.1 or later
* elixir 1.5.2 or later

You can easily install erlang and elixir dependencies using [asdf](https://github.com/asdf-vm/asdf). When you are using `asdf`, it
will automatically read the `.tool-versions` file and it will set the specific version of your erlang and elixir.

## Running the App

Just run `mix run --no-halt` to start the web server.

Then in your browser go to `http://localhost:4001/suppliers?checkin=1&checkout=2&destination=3&guests=3`.

Make sure you have the following query parameters(`checkin`, `checkout`, `destination` and `guest`) otherwise, it will return a 400 Bad Request Error. You can put any value on these parameters

For filtering the suppliers, You need to have a `suppliers` query parameter for e.g.

```
http://localhost:4001/suppliers?checkin=1&checkout=2&destination=3&guests=3&suppliers=supplier1,supplier3
```


## Runnig the test

Just run `mix test`


## TODO

* Add test on caching mechanism
* Add an http request recording like [exvcr](https://github.com/parroty/exvcr) to record http request on tests.



