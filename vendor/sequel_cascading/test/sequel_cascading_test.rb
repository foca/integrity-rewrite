require 'rubygems'
require 'test/unit'
require 'sequel'

DB = Sequel.connect('sqlite:/')

class Author < Sequel::Model
  set_schema do
    primary_key :id
  end
  create_table!
  one_to_many :posts
end

class Post < Sequel::Model
  set_schema do
    primary_key :id
    foreign_key :author_id, :authors
  end
  create_table!
  many_to_one :author
  one_to_many :comments
  one_to_many :nulled_items
  one_to_many :restricted_items
  is :cascading, :destroy => :comments, :nullify => :nulled_items, :restrict => :restricted_items
end

class Comment < Sequel::Model
  set_schema do
    primary_key :id
    foreign_key :post_id, :posts
  end
  create_table!
  many_to_one :post
end

class NulledItem < Sequel::Model
  set_schema do
    primary_key :id
    foreign_key :post_id, :posts
  end
  create_table!
  many_to_one :post
end

class RestrictedItem < Sequel::Model
  set_schema do
    primary_key :id
    foreign_key :post_id, :posts
  end
  create_table!
  many_to_one :post
end

class SequelCascadingTest < Test::Unit::TestCase
  def test_should_leave_orphans_when_destroyed
    author = Author.create
    post = author.add_post(Post.new)
    author.destroy
    assert !author.exists?
    assert post.exists?
    assert_equal author.id, post.author_id
  end

  def test_should_destroy_children_when_destroyed
    post = Post.create
    comment = post.add_comment(Comment.new)
    post.destroy
    assert !post.exists?
    assert !comment.exists?
  end

  def test_should_nullify_children_when_destroyed
    post = Post.create
    nulled = post.add_nulled_item(NulledItem.new)
    post.destroy
    assert !post.exists?
    assert nulled.exists?
    assert_nil post.author_id
  end

  def test_should_be_restricted_by_children_when_destroyed
    post = Post.create
    restricted = post.add_restricted_item(RestrictedItem.new)
    assert_raises(Sequel::Error::InvalidOperation) { post.destroy }
    assert post.exists?
    assert restricted.exists?
  end
end
