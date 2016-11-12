require 'victor'

# @param [Float] grad
# @return [Float]
def grad_to_rad(grad)
  grad * Math::PI / 180
end

# # @param [Float] rad
# # @return [Float]
# def rad_to_grad(rad)
#   rad * 180 / Math::PI
# end

class SmartC
  class << self
    def[](*args)
      self.new(*args)
    end
  end
end

class SPt < SmartC; end
class DPt < SmartC
  NAMES = [:x, :y, :z]
  attr_reader *NAMES
  NAMES.each do |n|
    define_method("c#{n}") { send(n).round(3) + 300 }
  end

  def initialize(x, y, z)
    @x, @y, @z = x, y, z
  end

  def to_spheric()
    SPt[
      Math.sqrt(x**2 + y**2 + z**2),
      Math.atan(Math.sqrt(x**2 + y**2) / z),
      Math.atan(y / x.to_f)
    ]
  end
end

class SPt
  attr_reader :r, :theta, :phi

  def initialize(r, theta, phi)
    @r, @theta, @phi = r, theta, phi
  end

  def rotate(dth, dp)
    SPt[@r, theta + dth, phi + dp]
  end

  def to_descart()
    DPt[
      r * Math.sin(theta) * Math.cos(phi),
      r * Math.sin(theta) * Math.sin(phi),
      r * Math.cos(theta)
    ]
  end
end

class Space

  DEFAULT_ANGLE = grad_to_rad(20) # grad
  DEFAULT_BOTTOM = 8 # points
  DEFAULT_BH = DEFAULT_BOTTOM / 2
  A = DEFAULT_BH * Math.cos(DEFAULT_ANGLE)
  B = DEFAULT_BH * Math.sin(DEFAULT_ANGLE)

  def initialize(width, height)
    @svg = SVG.new(width: width, height: height)
  end

  def save(filename)
    @svg.save("#{filename}.svg")
  end

  # @param [DPt] from
  # @param [DPt] to
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

  # @param [DPt] from
  # @param [DPt] to
  def line(from, to)
    css = { stroke: 'black', stroke_width: DEFAULT_BH * 0.5 }
    @svg.build do
      line(x1: from.cx, y1: from.cy, x2: to.cx, y2: to.cy, style: css)
    end
  end

  # @param [DPt] from
  # @param [DPt] to
  def black_tr(from, to)
    q = ex(from, 1, 1)
    t = ex(from, -1, -1)
    tr(to, q, t, fill: 'black')
  end

  # @param [DPt] from
  # @param [DPt] to
  def gray_tr(from, to)
    q = ex(from, -1, 1)
    t = ex(from, 1, -1)
    tr(to, q, t, fill: 'gray')
  end

  # @param [DPt] bottom
  # @param [DPt] top
  # @param [Hash] css
  def tr(*points, **css)
    str = points.map(&method(:pstr)).join(' ')
    @svg.build do
      polygon(points: str, **css)
    end
  end

  # @param [DPt] pt
  # @return [String]
  def pstr(pt)
    "#{pt.cx}, #{pt.cy}"
  end

  # @param [DPt] pt
  # @return [Number] kx
  # @return [Number] ky
  # @result [DPt]
  def ex(pt, kx, ky)
    DPt[pt.x + kx * A, pt.y + ky * B, 0]
  end
end

# @param [DPt] from
# @param [Number] side
# @return [Array]
def coub(from, side)
  side = side * 0.5
  [
    DPt[from.x - side, from.y - side, from.z - side],
    DPt[from.x - side, from.y + side, from.z - side],
    DPt[from.x + side, from.y + side, from.z - side],
    DPt[from.x + side, from.y - side, from.z - side],
    DPt[from.x - side, from.y - side, from.z + side],
    DPt[from.x - side, from.y + side, from.z + side],
    DPt[from.x + side, from.y + side, from.z + side],
    DPt[from.x + side, from.y - side, from.z + side]
  ]
end

# @param [Symbol] d
# @param [Array] points
# @return [Number]
def max_d(d, points)
  points.map(&d).max + 350
end

# @param [Array] cb
# @return [Space]
def space(cb)
  Space.new(max_d(:x, cb), max_d(:y, cb))
end

# @param [String] name
# @param [Array] cb
def draw_coub(name, cb)
  s = space(cb)
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
  s.save(name)
end

def name(angles)
  tail = angles.map(&:to_s).join('_')
  "coub_#{tail}"
end

def main(*angles)
  cb = coub(DPt[200, 200, 0], 100)
  cb = cb.map(&:to_spheric)
  # cb = cb.map { |pt| pt.rotate(*angles) }
  cb = cb.map(&:to_descart)
  draw_coub(name(angles), cb)
end

main(0, 0)
