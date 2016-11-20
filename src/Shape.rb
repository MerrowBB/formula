class Shape

  include Math

  properties :points

  def initialize(*points)
    @points = points
  end

  def rotate(*angles)

    points.map &:rotate(*angles)
  end

  def center
    
  end
end
