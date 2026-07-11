# frozen_string_literal: true

Jekyll::Hooks.register :site, :after_init do |site|
  replace_version = lambda do |value, version|
    case value
    when Hash
      value.transform_values! { |nested| replace_version.call(nested, version) }
    when String
      value.gsub("{{version}}", version.to_s)
    else
      value
    end
  end

  site.config.fetch("third_party_libraries", {}).each_value do |library|
    next unless library.is_a?(Hash) && library["version"] && library["url"]

    replace_version.call(library["url"], library["version"])
  end
end
