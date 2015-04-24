# Debsacker

[![Build status](https://travis-ci.org/konstantinous/debsacker.svg)](https://travis-ci.org/konstantinous/debsacker)

Build your application into debian package.

## Installation

Add this line to your application's Gemfile:

    gem 'debsacker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install debsacker

## Usage

``` sh
# create package with tag name as version and add distributive name to version
$ debsacker

# create package with custom version and without distributive name
$ debsacker -p 0.1.0 --no-distro

# create package with commit ref as version and add branch to version
$ debsacker -p commit -b

# create package with datetime as version
$ debsacker -p datetime
```

## Configure

In root path of your application should exists `debian` directory. You can read about required files here https://www.debian.org/doc/manuals/maint-guide/dreq.en.html

## Contributing

1. Fork it ( https://github.com/konstantinous/debsacker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
