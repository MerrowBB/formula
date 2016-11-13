# @param [Float] grad
# @return [Float]
def grad_to_rad(grad)
  grad * Math::PI / 180
end

# @param [Float] rad
# @return [Float]
def rad_to_grad(rad)
  rad * 180 / Math::PI
end
