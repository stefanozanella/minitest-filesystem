require "minitest/filesystem/version"
require "minitest/filesystem/matcher"

module Minitest::Assertions
  def assert_contains_filesystem(dir, msg = nil, &block)
    matcher = Minitest::Filesystem::Matcher.new(dir, &block)
    assert matcher.match_found?, msg || matcher.message
  end

  def filesystem(&block)
    block
  end
end

module Minitest::Expectations
  infect_an_assertion :assert_contains_filesystem, :must_exist_within
end
