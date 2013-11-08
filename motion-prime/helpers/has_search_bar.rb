# This module adds search functionality, to Screen or TableSection
module MotionPrime
  module HasSearchBar
    def add_search_bar(options = {}, &block)
      search_bar = create_search_bar
      search_bar.delegate = self

      if target = options[:target]
        target.addSubview search_bar
      elsif is_a?(TableSection)
        self.table_view.tableHeaderView = search_bar
      end

      @search_callback = block
    rescue
      puts "can't add search bar to #{self.class.name}"
    end

    def create_search_bar
      name = is_a?(TableSection) ? name : self.class.name.underscore
      screen = is_a?(TableSection) ? self.screen : self
      screen.search_bar(styles: [:"base_search_bar", :"#{name}_search_bar"]).view
    end

    def searchBar(search_bar, textDidChange: text)
      @search_callback.call(text)
    end

    def searchBarSearchButtonClicked(search_bar)
      search_bar.resignFirstResponder
    end
  end
end