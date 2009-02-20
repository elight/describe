namespace :shoulda do
  desc "List the names of the test methods in a specification like format for a single file"
  task :spec_list do
    def print_with_scope(content)
      puts((0...@indent).collect { "  " }.join + content)
    end

    module Thoughtbot
      module Shoulda
        class Context
          def build(indent = 0)
            @indent ||= indent
            print_with_scope self.name
            @indent += 1
            shoulds.each do |should|
              print_with_scope("should " + should[:name])
            end

            subcontexts.each { |ctx| ctx.build(@indent) }

            print_should_eventuallys
          end
        end
      end
    end

    Test::Unit::TestCase.class_eval { 
      def initialize(*args); exit; end
      def run(arg); exit; end
    }

    $LOAD_PATH.unshift("test")

    require 'rubygems'
    require 'active_support'

    test_files = ARGV.dup
    test_files.shift # pop the original rake target
    test_files.each do |file|
      require file
    end
  end
end


