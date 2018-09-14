shared_context :templates do
  def create_template(rendered_filepath: "#{rand(99_999)}.md", content: 'template')
    template_fixture = Struct.new(:path, :expected_rendered_filepath, :templates_directory)
    templates_directory = "#{Dir.pwd}/.templates"
    FileUtils.mkdir_p(templates_directory)
    template_path = "#{templates_directory}/#{rendered_filepath}.erb"
    File.write(template_path, content)
    template_fixture.new(full_path(template_path), full_path(rendered_filepath), full_path(templates_directory))
  end

  def full_path(path)
    File.expand_path(path)
  end
end
