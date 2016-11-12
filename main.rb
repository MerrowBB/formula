require 'victor'

class Pt
  class << self
    def [](x, y, z)
      self.new(x, y, z)
    end
  end

  attr_reader :x, :y, :z

  def initialize(x, y, z)
    @x, @y, @z = x, y, z
  end
end

class Formula

  DEFAULT_ANGLE = 20 * Math::PI / 180.0 # rad
  DEFAULT_BOTTOM = 8 # point
  DEFAULT_BH = DEFAULT_BOTTOM / 2
  A = DEFAULT_BH * Math.cos(DEFAULT_ANGLE)
  B = DEFAULT_BH * Math.sin(DEFAULT_ANGLE)

  def initialize(width, height)
    @svg = SVG.new(width: width, height: height)
  end

  def save(filename)
    @svg.save("#{filename}.svg")
  end

  # @param [Pt] from
  # @param [Pt] to
  def bond(from, to)
    if from.z == to.z
      line(from, to)
    elsif from.z > to.z && from.y > to.y
      black_tr(from, to)
    else
      gray_tr(from, to)
    end
  end

private

  # @param [Pt] from
  # @param [Pt] to
  def line(from, to)
    css = { stroke: 'black', stroke_width: DEFAULT_BH / 2 }
    @svg.build do
      line(x1: from.x, y1: from.y, x2: to.x, y2: to.y, style: css)
    end
  end

  # @param [Pt] from
  # @param [Pt] to
  def black_tr(from, to)
    q = ex(from, 1, 1)
    t = ex(from, -1, -1)
    tr(to, q, t, fill: 'black')
  end

  # @param [Pt] from
  # @param [Pt] to
  def gray_tr(from, to)
    q = ex(from, -1, 1)
    t = ex(from, 1, -1)
    tr(to, q, t, fill: 'gray')
  end

  # @param [Array] points
  # @param [Hash] css
  def tr(*points, **css)
    str = points.map(&method(:pstr)).join(' ')
    @svg.build do
      polygon(points: str, **css)
    end
  end

  # @param [Pt] pt
  # @return [String]
  def pstr(pt)
    "#{pt.x},#{pt.y}"
  end

  # @param [Pt] pt
  # @param [Number] kx
  # @param [Number] ky
  # @result [Pt]
  def ex(pt, kx, ky)
    Pt[pt.x + kx * A, pt.y + ky * B, 0]
  end
end

# @param [Array]
# @option [Number] :angle_x
# @option [Number] :angle_y
# @option [Number] :angle_z
# @return [Array]
def rotate(*points, angle_x: 0, angle_y: 0, angle_z: 0)
  # implement me!
end

def main
  lb = Pt[5, 55, 1]
  lm = Pt[25, 25, -1]
  lt = Pt[15, 5, 0]

  rb = Pt[65, 55, 1]
  rm = Pt[85, 25, -1]
  rt = Pt[75, 5, 0]

  ps = rotate(lb, lm, lt, rb, rm, rt)

  f = Formula.new(100, 100)
  f.bond(lb, lt)
  f.bond(lm, lt)
  f.bond(lt, rt)
  f.bond(rb, rt)
  f.bond(rm, rt)
  f.save('123')
end

main
