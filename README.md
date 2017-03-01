# Crux


Crux is a HTTP request router for [Crystal](https://github.com/crystal-lang/crystal), inspired by [mux](https://github.com/gorilla/mux). Crux aims to provide a flexible API with good ergonomics, without having any strong opinions on how you build your application. That means no Rails-style controllers, base classes, or mixins. Just pass a plain old `HTTP::Handler` or `HTTP::Handler::Proc` to each route and you're good to go.

## Roadmap
- [x] Basic API
- [ ] Path params
- [ ] ???
- [ ] Profit

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  crux:
    github: andrewhamon/crux
```

## Usage

A Crux router is a `HTTP::Handler`, so simply place it wherever you'd like in your middleware stack.
```crystal
require "http/server"
require "crux"

router = Crux::Router.new

router.path("/").handle do |context|
  context.response.print "Hello, world!"
end

HTTP::Server.new("127.0.0.1", 8080, [
  HTTP::ErrorHandler.new,
  HTTP::LogHandler.new,
  YourCustomAuthHandler.new,
  router,
]).listen
```

Combine match criteria on a single route:
```crystal
router = Crux::Router.new
router.host("example.com").method(:get, :head).scheme(:https).path("/foo").handler(some_handler)
```

Create multiple routes:
```crystal
router = Crux::Router.new

router.path("/foo").handler(foo_handler)
router.path("/bar").handler(bar_handler)
```

Use HTTP method aliases:
```crystal
router = Crux::Router.new

router.path("/").get.handler(get_handler)
router.path("/").post.handler(post_handler)
# and so on, for options, head, get, post, patch, put, delete
```

Create a subrouter:
```crystal
router = Crux::Router.new

subrouter = router.prefix("/v1")

subrouter.path("/foo").handler(foo_handler) # Matches /v1/foo
subrouter.path("/bar").handler(bar_handler) # Matches /v1/bar

router.path("/baz").handler(baz_handler) # Matches /baz, since it uses the root router
```

Get fancy with blocks, if that's your style. This is equivalent to the previous example:
```crystal
router = Crux::Router.new

router.prefix("/v1") do |subrouter|
  subrouter.path("/foo").handler(foo_handler)
  subrouter.path("/bar").handler(bar_handler)
end

router.path("/baz").handler(baz_handler)
```

Get extra freaky and drop the block params:
```crystal

router = Crux::Router.new

router.prefix("/v1") do
  path("/foo").handler(foo_handler)
  path("/bar").handler(bar_handler)
end

router.path("/baz").handler(baz_handler)
```

Nest as deep as you wish (please be responsible):
```crystal
router = Crux::Router.new do
  prefix("/v1") do
    path("/widgets") do
      get.handler(widgets_index)
      post.handler(new_widget)
    end
  end
end
```

## Contributing

1. Fork it ( https://github.com/andrewhamon/crux/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [andrewhamon](https://github.com/andrewhamon) Andrew Hamon - creator, maintainer
