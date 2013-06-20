# Minitest::Filesystem

Adds assertions and expectations to check filesystems content in a readable way.

## Installation

Add this line to your application's Gemfile:

    gem 'minitest-filesystem'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minitest-filesystem

Once the gem is installed, just add this line to your `test_helper.rb`:

    require 'minitest/filesystem'

## Usage

Let's suppose the following filesystem structure exists:

* `root_dir/`
  * `file_1`
  * `file_2`
  * `subdir_1/`
      * `subfile_1`
      * `subfile_2`
      * `subsubdir_1/`
  * `subdir_2/`

You can check if `root_dir` contains a specific structure:

    assert_contains_filesystem("root_dir") do
      file "file_1"
      dir "subdir_1" do
        file "subfile_1"
      end
      dir "subdir_2"
    end

or, if you prefer the expectation style:

    filesystem {
      file "file_1"
      dir "subdir_1" do
        file "subfile_1"
      end
      dir "subdir_2"
    }.must_exist_within "root_dir"

Note that the match **need not to be exact** (i.e. there can be other files and
directories inside `root_dir` that we don't care about).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
