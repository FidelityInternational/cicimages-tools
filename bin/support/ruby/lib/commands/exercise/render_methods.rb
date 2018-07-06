module Exercise
  module RenderMethods
    include Commandline::Output

    def render(template)
      ERB.new(File.read(template)).result(binding)
    ensure
      after_all_commands.each {|command| test_command(command)}
    end

    def render_exercise(original_dir, template)
      exercise_name = File.basename(original_dir)
      say "Generating file for: #{exercise_name}"

      result = anonymise(render(template))

      File.write(exercise_filename(template), result)

      say '' if quiet?
      say ok "Finished: #{exercise_name}"
    rescue CommandError => e
      say error "Failed to generate file from: #{template}"
      raise e
    end

    def render_exercises(original_dir)
      status = true

      templates.each do |template|
        Dir.chdir("#{__dir__}/../../../../../../")
        begin
          render_exercise(original_dir, template)
        rescue CommandError
          status = false
        end
        Dir.chdir(original_dir)
      end

      status
    end

    def templates
      Dir["#{Dir.pwd}/.templates/*.md.erb"]
    end

    def exercise_filename(template)
      "#{Dir.pwd}/#{File.basename(template, '.erb')}"
    end

    private

    def anonymise(string)
      string.gsub(/course-[\w\d]+/, 'course-xxxxxxxxxxxxxxxx')
          .gsub(/course:[\w\d]+/, 'course:xxxxxxxxxxxxxxxx')
    end
  end
end
