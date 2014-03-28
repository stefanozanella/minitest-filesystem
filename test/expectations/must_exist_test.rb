require 'test_helper'

describe "filesystem must_exist_within" do
  let(:a_path) { Pathname.new("/lmao/if/this/exists") }

  it "fails when the expected path doesn't exist" do
    l = lambda { a_path.must_exist }
    assert_raises(Minitest::Assertion, &l)
  end
end

