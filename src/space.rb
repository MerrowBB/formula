require 'victor'

require_relative 'points'
require_relative 'utils'

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
      line(x1: from.x, y1: from.y, x2: to.x, y2: to.y, style: css)
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
    "#{pt.x}, #{pt.y}"
  end

  # @param [DPt] pt
  # @return [Number] kx
  # @return [Number] ky
  # @result [DPt]
  def ex(pt, kx, ky)
    DPt[pt.x + kx * A, pt.y + ky * B, 0]
  end
end
