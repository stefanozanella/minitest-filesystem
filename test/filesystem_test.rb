require 'test_helper'
require 'tmpdir'
require 'fileutils'

describe "assert_contains_filesystem" do
  before do
    @root_dir = Pathname.new(Dir.mktmpdir('minitestfs'))

    (@root_dir + 'a_directory').mkdir
    (@root_dir + 'a_subdirectory').mkdir
    (@root_dir + 'not_a_file').mkdir
    (@root_dir + 'unchecked_dir').mkdir

    FileUtils.touch(@root_dir + 'a_file')
    FileUtils.touch(@root_dir + 'not_a_dir')
    FileUtils.touch(@root_dir + 'a_subdirectory' + 'another_file')
    FileUtils.touch(@root_dir + 'unchecked_file')
  end

  after do
    FileUtils.rm_rf @root_dir
  end

  it "passes with empty expected tree" do
    assert_contains_filesystem(@root_dir) {}
  end

  it "passes when single file found" do
    assert_contains_filesystem(@root_dir) do
      file "a_file"
    end
  end

  it "passes when single directory found" do
    assert_contains_filesystem(@root_dir) do
      dir "a_directory"
    end
  end

  it "passes when a file within a subdirectory is found" do
    assert_contains_filesystem(@root_dir) do
      dir "a_subdirectory" do
        file "another_file"
      end
    end
  end

  it "fails when an expected file isn't found" do
    l = lambda { assert_contains_filesystem(@root_dir) do
      file "foo"
    end }

    error = assert_raises(MiniTest::Assertion, &l)
    error.message.must_match(/expected `#{@root_dir}` to contain file `foo`/im)
  end

  it "fails when an expected directory isn't found" do
    l = lambda { assert_contains_filesystem(@root_dir) do
      dir "bar"
    end }

    error = assert_raises(MiniTest::Assertion, &l)
    error.message.must_match(/expected `#{@root_dir}` to contain directory `bar`/im)
  end

  it "fails when an expected file within a subdirectory isn't found" do
    l = lambda { assert_contains_filesystem(@root_dir) do
      dir "a_subdirectory" do
        file "missing_file"
      end
    end }

    error = assert_raises(MiniTest::Assertion, &l)
    error.message.must_match(
      /expected `#{@root_dir + 'a_subdirectory'}` to contain file `missing_file`/im
    )
  end

  it "fails when a directory is expected to be a file" do
    l = lambda { assert_contains_filesystem(@root_dir) do
      file "not_a_file"
    end }

    error = assert_raises(MiniTest::Assertion, &l)
    error.message.must_match(/expected `not_a_file` to be a file/im)
  end

  it "fails when a file is expected to be a directory" do
    l = lambda { assert_contains_filesystem(@root_dir) do
      dir "not_a_dir"
    end }

    error = assert_raises(MiniTest::Assertion, &l)
    error.message.must_match(/expected `not_a_dir` to be a directory/im)
  end
end
