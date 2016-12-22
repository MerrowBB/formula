class Shape
  def initialize(points)
    @points = points
  end

  def points
    @points
  end

  def center
    cen_x = (@points.max_by{ |pt| pt.x }.x + @points.min_by{ |pt| pt.x }.x) / 2
    cen_y = (@points.max_by{ |pt| pt.y }.y + @points.min_by{ |pt| pt.y }.y) / 2
    cen_z = (@points.max_by{ |pt| pt.z }.z + @points.min_by{ |pt| pt.z }.z) / 2
    DPt[cen_x, cen_y, cen_z]
  end

  def rotate(*angles)
    move_points = Array.new(@points.map { |pt| pt - center })
    move_points = move_points.map { |pt| pt.spheric.rotate(*angles).descart }
    Shape.new(move_points.map { |pt| pt + center })
  end
end
