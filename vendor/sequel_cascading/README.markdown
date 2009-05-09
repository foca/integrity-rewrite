# sequel\_cascading

my take on cascading deletes via a plugin for sequel

## WHY?

DRY up my code.

No more explicit `before_destroy` to delete the children of `one_to_many`
associations.

## Installation

Run the following if you haven't already:

    $ gem sources -a http://gems.github.com
  
Install the gem(s):

    $ sudo gem install -r sbfaulkner-sequel_cascading

## Example

    require 'rubygems'
    require 'sequel'
    
    class Comment < Sequel::Model
      many_to_one :post
    end
    
    class Post < Sequel::Model
      one_to_many :comment, :order => :name
      
      # destroy any associated records too
      is :cascading, :destroy => :comments
      
      # or, if you want to null the foreign key instead, you could...
      # is :cascading, :nullify => :comments
      
      # or, if you want the destroy to fail, you would...
      # is :cascading, :restrict => :comments
    end

## UPDATES

### 1.0.3

- added support for :nullify and :restrict options
    
## TODO

- add :null and :deny support?
- publish in sequel www/pages/plugins

## Legal

**Author:** S. Brent Faulkner <brentf@unwwwired.net>  
**License:** Copyright &copy; 2009 unwwwired.net, released under the MIT license
