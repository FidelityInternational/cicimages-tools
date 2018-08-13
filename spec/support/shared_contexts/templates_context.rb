shared_context :templates do
  def create_template(rendered_filepath: "#{rand(99_999)}.md", content: 'template')
    template_fixture = Struct.new(:path, :expected_rendered_filepath)
    FileUtils.mkdir_p('.templates')
    template_path = ".templates/#{rendered_filepath}.erb"
    File.write(template_path, content)
    template_fixture.new(template_path, rendered_filepath)
  end
end
