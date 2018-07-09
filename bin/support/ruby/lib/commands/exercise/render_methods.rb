module Exercise
  module RenderMethods
    include Commandline::Output
    include Instructions

    def render_exercises(dir = Dir.pwd, quiet: true)
      status = true
      original_dir = Dir.pwd
      templates(dir).each do |template|
        begin
          render_exercise(original_dir, template, quiet: quiet)
        rescue StandardError
          status = false
        end
        Dir.chdir(original_dir)
      end

      status
    end

    private
    def anonymise(string)
      string.gsub(/course-[\w\d]+/, 'course-xxxxxxxxxxxxxxxx')
            .gsub(/course:[\w\d]+/, 'course:xxxxxxxxxxxxxxxx')
    end

    def exercise_filename(template)
      "#{Dir.pwd}/#{File.basename(template, '.erb')}"
    end

    def render(template)
      ERB.new(File.read(template)).result(binding)
    ensure
      after_all_commands.each { |command| test_command(command) }
    end

    def render_exercise(original_dir, template, quiet:)
      exercise_name = File.basename(original_dir)
      say "Generating file for: #{exercise_name}"

      result = anonymise(render(template))

      File.write(exercise_filename(template), result)

      say '' if quiet
      say ok "Finished: #{exercise_name}"
    rescue CommandError => e
      say error "Failed to generate file from: #{template}"
      raise e
    end

    def templates(dir)
      Dir["#{dir}/.templates/*.md.erb"]
    end
  end
end
