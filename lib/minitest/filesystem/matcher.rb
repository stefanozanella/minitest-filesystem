require 'pathname'

module MiniTest
  module FileSystem
    class Matcher
      def initialize(root, &block)
        @actual_tree = MatchingTree.new(root)
        @expected_tree = block
        @is_matching = true
      end

      def file(file)
        entry(:file, file) && is_a?(:file, file)
      end

      def dir(dir, &block)
        matcher = self.class.new(@actual_tree.root + dir, &block) if block_given?

        entry(:directory, dir) && is_a?(:directory, dir) && subtree(matcher)
      end

      def entry(kind = :entry, entry)
        @is_matching = @is_matching && @actual_tree.include?(entry)
        set_failure_msg_for(kind, entry) unless @is_matching

        @is_matching
      end

      def match_found?
        instance_eval(&@expected_tree)
        @is_matching
      end

      def message
        @failure_msg || ""
      end

      private

      def subtree(matcher)
        @is_matching = @is_matching && matcher.match_found? if matcher
        set_failure_msg(matcher.message) unless @is_matching

        @is_matching
      end

      def is_a?(kind, entry)
        @is_matching = @is_matching && (@actual_tree.is_a?(kind, entry))
        set_mismatch_failure_msg_for(kind, entry) unless @is_matching

        @is_matching
      end

      def set_failure_msg_for(kind, entry)
        set_failure_msg "Expected `#{@actual_tree.root}` to contain #{kind} `#{entry}`."
      end

      def set_failure_msg(msg)
        @failure_msg ||= msg
      end

      def set_mismatch_failure_msg_for(kind, entry)
        @failure_msg ||=
          "Expected `#{entry}` to be a #{kind}, but it was not."
      end

      class MatchingTree
        attr_reader :root

        def initialize(root)
          @root = Pathname.new(root)
          @tree = expand_tree_under @root
        end

        def include?(entry)
          @tree.include?(root_slash(entry))
        end

        def is_a?(kind, entry)
          (root_slash entry).send("#{kind}?")
        end

        private
        
        def expand_tree_under(dir)
          Pathname.glob(dir.join("**/*"))
        end

        def root_slash(file)
          @root + Pathname.new(file)
        end
      end
    end
  end
end
