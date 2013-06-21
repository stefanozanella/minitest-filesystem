require 'pathname'

module Minitest
  module Filesystem
    class Matcher
      def initialize(root, &block)
        @actual_tree = MatchingTree.new(root)
        @expected_tree = block
        @is_matching = true
      end

      def file(file)
        entry(file, :file) && is_a?(file, :file)
      end

      def dir(dir, &block)
        matcher = self.class.new(@actual_tree.expand_path(dir), &block) if block_given?

        entry(dir, :directory) && is_a?(dir, :directory) && subtree(matcher)
      end

      def match_found?
        instance_eval(&@expected_tree)
        @is_matching
      end

      def message
        @failure_msg || ""
      end

      private

      def entry(entry, kind=:entry)
        update_matching_status(
          @actual_tree.include?(entry),
          not_found_msg_for(entry, kind))
      end

      def subtree(matcher)
        update_matching_status(matcher.match_found?, matcher.message) if matcher
      end

      def is_a?(entry, kind)
        update_matching_status(
          @actual_tree.is_a?(entry, kind),
          mismatch_msg_for(entry, kind))
      end

      def update_matching_status(check, msg)
        @is_matching = @is_matching && check
        set_failure_msg(msg) unless @is_matching

        @is_matching
      end

      def not_found_msg_for(entry, kind)
        "Expected `#{@actual_tree.root}` to contain #{kind} `#{entry}`."
      end

      def mismatch_msg_for(entry, kind)
        "Expected `#{entry}` to be a #{kind}, but it was not."
      end

      def set_failure_msg(msg)
        @failure_msg ||= msg
      end

      class MatchingTree
        attr_reader :root

        def initialize(root)
          @root = Pathname.new(root)
          @tree = expand_tree_under @root
        end

        def include?(entry)
          @tree.include?(expand_path(entry))
        end

        def is_a?(entry, kind)
          (expand_path entry).send("#{kind}?")
        end

        def expand_path(file)
          @root + Pathname.new(file)
        end

        private
        
        def expand_tree_under(dir)
          Pathname.glob(dir.join("**/*"))
        end
      end
    end
  end
end
