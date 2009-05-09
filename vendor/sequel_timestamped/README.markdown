# sequel\_timestamped

my take on a timestamping plugin for sequel

## WHY?

The existing implementations I saw checked for the attributes every time a
record was saved. This version checks when plugged in.

Additionally, the updated\_by attribute is explicitly settable in at least one
other implementation. It's not in this one (by design).

## Installation

Run the following if you haven't already:

    $ gem sources -a http://gems.github.com

Install the gem(s):

    $ sudo gem install -r sbfaulkner-sequel_timestamped

## Example

    require 'rubygems'
    require 'sequel'

    class Post < Sequel::Model
      is :timestamped, :using => :utc
    end

## UPDATES

### 1.0.3

- add support for utc (or localtime) by passing option :using => :utc (or :localtime)

## TODO

- maybe rename sequel\_audited
- add created\_by and updated\_by support?
- publish in sequel www/pages/plugins

## Legal

**Author:** S. Brent Faulkner <brentf@unwwwired.net>
**License:** Copyright &copy; 2009 unwwwired.net, released under the MIT license
