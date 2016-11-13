require 'pry'

require_relative 'src/space'

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
  points.map(&d).max + 50
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

def full_name(angles)
  tail = angles.map(&:to_s).join('_')
  "coub_#{tail}"
end

def main(*angles)
  cb = coub(DPt[200, 200, 0], 100)
  cb = cb.map(&:spheric)
  # cb = cb.map { |pt| pt.rotate(*angles) }
  cb = cb.map(&:descart)
  cb = cb.map { |pt| pt + DPt[100, 100, 0] }
  draw_coub(full_name(angles), cb)
end

main(0, 0)
