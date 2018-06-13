module LearnOpen
  module Lessons
    class BaseLesson
      attr_reader :repo_path,
                  :organization,
                  :name,
                  :id,
                  :dot_learn,
                  :git_server,
                  :later_lesson,
                  :options,
                  :io,
                  :system_adapter,
                  :platform,
                  :environment_vars,
                  :logger,
                  :location

      def initialize(lesson_data, options = {})
        lesson = lesson_data[:lesson]

        @repo_path = lesson.clone_repo
        @organization, @name = repo_path.split('/')

        @git_server = lesson.git_server
        @dot_learn = lesson.dot_learn
        @is_lab = lesson.lab
        @later_lesson = lesson_data[:later_lesson]
        @id = lesson_data[:id]

        @logger = options.fetch(:logger, LearnOpen.logger)
        @io = options.fetch(:io, LearnOpen.default_io)
        @system_adapter = options.fetch(:system_adapter, LearnOpen.system_adapter)
        @platform = options.fetch(:platform, LearnOpen.platform)
        @environment_vars = options.fetch(:environment_vars, LearnOpen.environment_vars)
        @location = options.fetch(:lessons_directory) {LearnOpen.lessons_directory}
        @options = options
      end

      def lab?
        @is_lab
      end

      def readme?
        !lab?
      end

      def warn_if_necessary
        return unless self.later_lesson

        io.puts 'WARNING: You are attempting to open a lesson that is beyond your current lesson.'
        io.print 'Are you sure you want to continue? [Yn]: '

        warn_response = io.gets.chomp.downcase
        exit if !['yes', 'y'].include?(warn_response)
      end

      def to_path
        "#{location}/#{name}"
      end
    end
  end
end
