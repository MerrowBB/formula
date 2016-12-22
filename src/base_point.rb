class BasePoint
  include Math

  EPS = 0.01

  def round(n)
    n.round(5)
  end

  class << self
    def [](*args)
      self.new(*args)
    end

    def properties(*names)
      define_method(:==) { |other| same?(other, *names) }

      define_method(:+) do |delta|
        sv = method(:send)
        dv = delta.method(:send)
        args = names.map(&sv).zip(names.map(&dv)).map { |v, d| v + d }
        self.class[*args]
      end

      define_method(:-) do |delta|
        sv = method(:send)
        dv = delta.method(:send)
        args = names.map(&sv).zip(names.map(&dv)).map { |v, d| v - d }
        self.class[*args]
      end

      names.each do |name|
        define_method(name) do
          round(instance_variable_get(:"@#{name}"))
        end
      end
    end
  end

private

  def same?(other, *names)
    equal?(other) || names.all? do |name|
      (send(name) - other.send(name)).abs < EPS
    end
  end
end
