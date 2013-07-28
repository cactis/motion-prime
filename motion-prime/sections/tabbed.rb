module MotionPrime
  class TabbedSection < BaseSection
    # MotionPrime::TabbedSection is base class for building tabbed views.

    # == Basic Sample
    # class MySection < MotionPrime::TabbedSection
    #   tab :info, default: true, page_section: :info_tab
    #   tab :map, page_section: :map_tab
    #   # page_section options will be converted to section class and added to section.
    #   # e.g. in this sample: InfoTabSection.new(model: model).render(to: screen)
    # end
    #

    class_attribute :tabs_options, :tabs_default
    attr_accessor :tab_pages

    element :control, type: :segmented_control,
      styles: [:base_segmented_control], items: proc { tab_control_items }

    after_render :render_tab_pages
    after_render :render_tab_controls

    def tab_options
      @tab_options ||= self.class.tabs_options
    end

    def tab_control_items
      @tab_control_items ||= tab_options.values.map{ |o| o[:name] }
    end

    def tab_default
      @tab_default ||= self.class.tabs_default || 0
    end

    def render_tab_pages
      @tab_pages = []
      index = 0
      tab_options.each do |key, options|
        section_class = options[:page_section].classify
        page = "::#{section_class}Section".constantize.new(model: model)
        page.render(to: screen)
        page.hide if index != tab_default
        @tab_pages << page
        index += 1
      end
    end

    def render_tab_controls
      control = element(:control).view
      control.addTarget(
        self, action: :on_click, forControlEvents: UIControlEventValueChanged
      )
      control.setSelectedSegmentIndex(tab_default)
    end

    # on clicn to control
    # @param UISegemtedControl control
    def on_click(*control)
      @tab_pages.each_with_index do |page, i|
        page.hide if control.selectedSegment != i
      end
      @tab_pages[control.selectedSegment].show
    end

    class << self
      def tab(id, options = {})
        options[:name] = id.to_s.titleize
        options[:id] = id

        self.tabs_options ||= {}
        self.tabs_default = tabs_options.length if options[:default]
        self.tabs_options[id] = options
      end
    end
  end
end