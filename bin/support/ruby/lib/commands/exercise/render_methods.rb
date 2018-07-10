module Exercise
  module RenderMethods
    include Commandline::Output
    include Instructions

    def render_exercises(dir)
      status = true
      original_dir = Dir.pwd
      templates(dir).each do |template|
        begin
          render_exercise(dir, template)
        rescue StandardError
          status = false
        end
        Dir.chdir(original_dir)
      end

      status
    end

    def render_exercise(exercise_directory, template)
      exercise_name = File.basename(exercise_directory)
      say "Generating file for: #{exercise_name}"

      result = anonymise(render(template))

      File.write(exercise_filename(template), result)

      say '' if quiet?
      say ok "Finished: #{exercise_name}"
    rescue StandardError => e
      say error "Failed to generate file from: #{template}"
      raise e
    end

    private

    def anonymise(string)
      string.gsub(/course-[\w\d-]+/, 'course-xxxxxxxxxxxxxxxx')
            .gsub(/course:[\w\d-]+/, 'course:xxxxxxxxxxxxxxxx')
    end

    def exercise_filename(template)
      "#{Dir.pwd}/#{File.basename(template, '.erb')}"
    end

    def render(template)
      ERB.new(File.read(template)).result(binding)
    ensure
      after_all_commands.each { |command| test_command(command) }
    end

    def templates(dir)
      Dir["#{dir}/.templates/*.md.erb"]
    end
  end
end
