require 'victor'

# descart: x, y, z
# spheric: r, theta, phi
class Pt
  class << self
    def[](x, y, z)
      self.new(x, y, z)
    end
  end

  attr_reader :x, :y, :z

  def initialize(x, y, z)
    @x, @y, @z = x, y, z
  end

  def to_spheric()
    new_x = Math.sqrt( x**2 + y**2 + z**2 )
    new_y = Math.atan( Math.sqrt( x**2 + y**2 ) / z )
    new_z = Math.atan( y / x )
    return Pt[new_x, new_y, new_z]
  end

  def to_descart()
    new_x = x * Math.sin(y) * Math.cos(z)
    new_y = x * Math.sin(y) * Math.sin(z)
    new_z = x * Math.cos(y)
    return Pt[new_x, new_y, new_z]
  end

end

class Space

  DEFAULT_ANGLE = 20 * Math::PI / 180.0 #grad
  DEFAULT_BOTTOM = 8  #points
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

  # @param [Pt] bottom
  # @param [Pt] top
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
    "#{pt.x}, #{pt.y}"
  end

  # @param [Pt] pt
  # @return [Number] kx
  # @return [Number] ky
  # @result [Pt]
  def ex(pt, kx, ky)
    Pt[pt.x + kx * A, pt.y + ky * B, 0]
  end
end

# @param [Pt] from
# @param [Number] side
# @return [Array]
def coub(from, side)
  side = side / 2
  [ Pt[from.x - side, from.y - side, from.z - side], Pt[from.x - side, from.y + side, from.z - side],
    Pt[from.x + side, from.y + side, from.z - side], Pt[from.x + side, from.y - side, from.z - side],
    Pt[from.x - side, from.y - side, from.z + side], Pt[from.x - side, from.y + side, from.z + side],
    Pt[from.x + side, from.y + side, from.z + side], Pt[from.x + side, from.y - side, from.z + side] ]
end

# @param [Space] s
# @param [Array] cb
def draw_coub(s, cb)
  s.bond(cb[0], cb[1])
  s.bond(cb[1], cb[2])
  s.bond(cb[2], cb[3])
  s.bond(cb[3], cb[0])
  s.bond(cb[4], cb[5])
  s.bond(cb[5], cb[6])
  s.bond(cb[6], cb[7])
  s.bond(cb[7], cb[4])
  s.bond(cb[0], cb[4])
  s.bond(cb[1], cb[5])
  s.bond(cb[2], cb[6])
  s.bond(cb[3], cb[7])
end

# @param [Array]
# @option [Number] :angle_x
# @option [Number] :angle_y
# @option [Number] :angle_z
# @return [Array]
def rotate(points, angle_x, angle_y, angle_z)
  new_points = Array.new
  points.each do |pt|
      y = pt.y * Math.cos(angle_x) - pt.z * Math.sin(angle_x)
      z = pt.y * Math.sin(angle_x) + pt.z * Math.cos(angle_x)

      x = pt.x * Math.cos(angle_y) + z * Math.sin(angle_y)
      z = - x * Math.sin(angle_y) + z * Math.cos(angle_y)

      x = x * Math.cos(angle_z) - y * Math.sin(angle_z)
      y = x * Math.sin(angle_z) + y * Math.cos(angle_z)

      new_points << Pt[x, y, z]
  end
  return new_points
end

def main
  s = Space.new(300, 300)
  cb = coub(Pt[150,150,0], 100)
  cb = rotate(cb, Math::PI/12, Math::PI/12, 0)
  draw_coub(s, cb)
  s.save('coub')
end

main
