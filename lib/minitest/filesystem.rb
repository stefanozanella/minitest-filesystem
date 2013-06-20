require "minitest/filesystem/version"
require "minitest/filesystem/matcher"

module MiniTest::Assertions
  def assert_contains_filesystem(dir, msg = nil, &block)
    matcher = MiniTest::FileSystem::Matcher.new(dir, &block)
    assert matcher.match_found?, msg || matcher.message
  end
end
