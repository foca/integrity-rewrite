require 'rubygems'
require 'test/unit'
require 'sequel'

DB = Sequel.connect('sqlite:/')

class ItemWithoutTimestamps < Sequel::Model
  set_schema do
    primary_key :id
    varchar :text
  end
  create_table!
  is :timestamped
end

class ItemWithTimestamps < Sequel::Model
  set_schema do
    primary_key :id
    varchar :text
    datetime :created_at
    datetime :updated_at
  end
  create_table!
  is :timestamped
end

class Time
  NOW = Time.now

  def self.now
    Time.at(NOW)
  end
end

class SequelTimestampedTest < Test::Unit::TestCase
  def test_should_create_without_timestamps
    assert ItemWithoutTimestamps.create
  end

  def test_should_update_without_timestamps
    item = ItemWithoutTimestamps.create
    item.update(:text => 'updated').valid?
  end

  def test_should_create_with_timestamps
    item = ItemWithTimestamps.create
    assert_equal Time::NOW.to_i, item.created_at.to_i, "expected to be now"
    assert_equal Time::NOW.to_i, item.updated_at.to_i, "expected to be now"
  end

  def test_should_create_with_specific_created_at
    a_day_ago = Time.new - 24 * 60 * 60
    item = ItemWithTimestamps.create(:created_at => a_day_ago)
    assert_equal a_day_ago.to_i, item.created_at.to_i, "expected to be a day ago"
  end

  def test_should_update_with_specific_created_at
    a_day_ago = Time.new - 24 * 60 * 60
    item = ItemWithTimestamps.create
    item.update(:created_at => a_day_ago)
    assert_equal a_day_ago.to_i, item.created_at.to_i, "expected to be a day ago"
  end

  def test_should_update_with_timestamp
    item = ItemWithTimestamps.create
    item.update(:updated_at => nil)
    assert_equal Time::NOW.to_i, item.updated_at.to_i, "expected to be now"
  end

  def test_should_not_update_with_specific_timestamp
    item = ItemWithTimestamps.create
    item.update(:updated_at => Time.new - 24 * 60 * 60)
    assert_equal Time::NOW.to_i, item.updated_at.to_i, "expected to be now"
  end
end
