# Minitest::Filesystem

[![Gem Version](https://badge.fury.io/rb/minitest-filesystem.png)](http://badge.fury.io/rb/minitest-filesystem)
[![Build Status](https://travis-ci.org/stefanozanella/minitest-filesystem.png?branch=master)](https://travis-ci.org/stefanozanella/minitest-filesystem)
[![Code Climate](https://codeclimate.com/github/stefanozanella/minitest-filesystem.png)](https://codeclimate.com/github/stefanozanella/minitest-filesystem)
[![Coverage Status](https://coveralls.io/repos/stefanozanella/minitest-filesystem/badge.png?branch=master)](https://coveralls.io/r/stefanozanella/minitest-filesystem?branch=master)

Adds assertions and expectations to check filesystem content in a communicative way.

## Installation

Add this line to your application's Gemfile:

    gem 'minitest-filesystem'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minitest-filesystem

Once the gem is installed, just add this line to your `test_helper.rb`:

```ruby
require 'minitest/filesystem'
```

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

```ruby
assert_contains_filesystem("root_dir") do
  file "file_1"
  dir "subdir_1" do
    file "subfile_1"
  end
  dir "subdir_2"
end
```

or, if you prefer the expectation style:

```ruby
filesystem {
  file "file_1"
  dir "subdir_1" do
    file "subfile_1"
  end
  dir "subdir_2"
}.must_exist_within "root_dir"
```

Note that the match **need not to be exact** (i.e. there can be other files and
directories inside `root_dir` that the matcher won't care about).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changelog

### 1.0.1

* Remove CamelCase naming.

### 1.0.0

* Add support for Ruby 1.8.

### 0.1.0

* Refactor existing code
* Add more tests around assertion
* Infect `must_exist_within` expectation

### 0.0.1

* Extract assertion and matcher from current projects
