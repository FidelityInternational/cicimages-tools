require 'digest'
require 'tmpdir'
module Exercise
  module RenderMethods
    class EnvironmentVariableMissingError < StandardError
      def initialize(variable_name)
        super "Environment variable not set for: #{variable_name}"
      end
    end

    include Commandline::Output
    include Instructions

    def env(variable_name)
      ENV[variable_name.to_s] || raise(EnvironmentVariableMissingError.new(variable_name))
    end

    def render_exercise(template)
      say "Rendering: #{template}"
      current_dir = Dir.pwd

      result = anonymise(render(template))
      result << "  \n\nRevision: #{digest(template)}"
      File.write(rendered_file_name(template), result)

      say ok "Finished: #{template}"
      true
    rescue StandardError => e
      say error "Failed to generate file from: #{template}"
      say "#{e.message}\n#{e.backtrace}"
      false
    ensure
      Dir.chdir(current_dir)
    end

    def substitute(hash)
      @substitutes = hash
    end

    private

    def anonymise(string)
      substitutes.each do |key, value|
        string = string.gsub(key, value)
      end
      string.gsub(/cic_container-[\w\d-]+/, 'cic_container-xxxxxxxxxxxxxxxx')
    end

    def digest(template)
      Digest::SHA2.file(template).hexdigest
    end

    def rendered_file_name(template)
      "#{Dir.pwd}/#{File.basename(template, '.erb')}"
    end

    def render(template)
      template_content = File.read(File.expand_path(template))

      erb_template = ERB.new(template_content)
      if /<%#\s*instruction:run_in_temp_directory\s*%>/.match?(template_content)
        return anonymise(render_in_temp_dir(erb_template))
      end
      anonymise(erb_template.result(binding))
    ensure
      after_rendering_commands.each { |command| test_command(command) }
      say '' if quiet?
    end

    def substitutes
      @substitutes ||= {}
    end

    def templates(dir)
      templates = {}
      Dir["#{dir}/.templates/*.md.erb"].each do |template|
        templates[File.basename(template)] = template
      end
      templates
    end

    def render_in_temp_dir(erb_template)
      output = nil
      Dir.mktmpdir do |path|
        original_dir = Dir.pwd
        Dir.chdir(path)
        output = erb_template.result(binding)
        Dir.chdir(original_dir)
      end
      output
    end
  end
end
