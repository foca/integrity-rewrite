%w(url pretty_output accessor).each do |helper|
  require "integrity/helpers/#{helper}_helper"
end

module Integrity
  module Helpers
    include UrlHelper, PrettyOutputHelper, AccessorHelper
  end
end
