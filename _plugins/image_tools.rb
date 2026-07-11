# frozen_string_literal: true

module LocalImageTools
  class StylesTag < Liquid::Tag
    def render(_context)
      ""
    end
  end

  class ScriptsTag < Liquid::Tag
    def render(context)
      site = context["site"]
      page = context.registers[:page]
      page_images = page && page["images"]
      page_images = {} unless page_images.is_a?(Hash)
      return "" unless site["enable_medium_zoom"] || page_images["medium_zoom"]

      baseurl = site["baseurl"].to_s
      <<~HTML
        <!-- Medium Zoom JS -->
        <script
          defer
          src="https://cdn.jsdelivr.net/npm/medium-zoom@1.1.0/dist/medium-zoom.min.js"
          integrity="sha256-ZgMyDAIYDYGxbcpJcfUnYwNevG/xi9OHKaR/8GK+jWc="
          crossorigin="anonymous"
        ></script>
        <script defer src="#{baseurl}/assets/js/zoom.js"></script>
      HTML
    end
  end
end

Jekyll::Hooks.register :site, :after_init do |site|
  site.config["plugins"] << "al_img_tools" unless site.config["plugins"].include?("al_img_tools")
end

Liquid::Template.register_tag("al_img_tools_styles", LocalImageTools::StylesTag)
Liquid::Template.register_tag("al_img_tools_scripts", LocalImageTools::ScriptsTag)
