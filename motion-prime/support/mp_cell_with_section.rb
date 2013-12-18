class MPCellWithSection < UITableViewCell
  attr_accessor :section

  def setSection(section)
    @section = section
  end

  def drawRect(rect)
    super
    draw_in(rect)
  end

  def draw_in(rect)
    section.draw_in(rect) if section.respond_to?(:draw_in)
  end
end