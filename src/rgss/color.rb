class Color

  attr_accessor :red, :green, :blue, :alpha

  def initialize(red, green, blue, alpha=255)
    @red, @green, @blue, @alpha = red, green, blue, alpha
  end

  def _dump(limit)
    [@red, @green, @blue, @alpha].pack("EEEE")
  end

  def self._load(obj)
    Color.new(*obj.unpack("EEEE"))
  end

end
