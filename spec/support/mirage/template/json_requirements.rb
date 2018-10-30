module Mirage
  class Template
    module JSONRequirements
      def json_requirement(name)
        define_method name do |value = nil|
          variable_name = :"@#{name}"
          return instance_variable_get(variable_name) unless value

          instance_variable_set(variable_name, value)
          required_body_content << %("#{name}":#{value.to_json})
        end
      end
    end
  end
end
