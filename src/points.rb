require_relative 'base_point'
require_relative 'utils'

# predefine
class SPt < BasePoint; end
class DPt < BasePoint; end

class DPt
  properties :x, :y, :z

  def initialize(x, y, z)
    @x, @y, @z = x, y, z
  end

  def rotate(dx, dy, dz)
    dx, dy, dz = grad_to_rad(dx), grad_to_rad(dy), grad_to_rad(dz)

    new_y = y * Math.cos(dx) - z * Math.sin(dx) 
    new_z = y * Math.sin(dx) + z * Math.cos(dx) 

    new_x = x * Math.cos(dy) + new_z * Math.sin(dy) 
    res_z = - x * Math.sin(dy) + new_z * Math.cos(dy) 

    res_x = new_x * Math.cos(dz) - new_y * Math.sin(dz) 
    res_y = new_x * Math.sin(dz) + new_y * Math.cos(dz) 

    DPt[res_x, res_y, res_z]
  end

  def spheric
    r = sqrt(x**2 + y**2 + z**2)
    SPt[
      r,
      r == 0 ? 0 : acos(z / r.to_f),
      r == 0 ? 0 : atan2(y, x),
    ]
  end

  def inspect
    { x: x, y: y, z: z }.to_s
  end
end


class SPt
  properties :r, :theta, :phi

  class << self
    include Math

    def recut(th, p)
      rth, rp = reth(th, p)
      [rth, rep(rp)]
    end

  private

    def reth(th, p)
      if th == 0
        [0, 0]
      elsif th < 0
        p <= 0 ? reth(-th, PI - p) : reth(-th, PI + p)
      elsif th > PI
        reth(2 * PI - th, p)
      else
        [th, p]
      end
    end

    def rep(p)
      if p == 0
        0
      elsif p < 0
        rep(2 * PI + p)
      elsif p > 2 * PI
        rep(p - 2 * PI)
      else
        p
      end
    end
  end

  def initialize(r, theta, phi)
    if r >= 0
      @r = r
      @theta, @phi = self.class.recut(theta, phi)
    else
      @r = -r
      @theta, @phi = self.class.recut(theta + PI, phi + PI)
    end
  end

  def rotate(dth, dp)
    SPt[r, theta + dth, phi + dp]
  end

  def descart
    DPt[
      r * sin(theta) * cos(phi),
      r * sin(theta) * sin(phi),
      r * cos(theta)
    ]
  end

  def inspect
    { r: r, theta: round(rad_to_grad(theta)), phi: round(rad_to_grad(phi)) }.to_s
  end
end
