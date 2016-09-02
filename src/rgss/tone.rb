class Tone

  attr_accessor :red, :green, :blue, :gray

  def initialize(red, green, blue, gray=0)
    @red, @green, @blue, @gray = red, green, blue, gray
  end

  def _dump(limit)
    [@red, @green, @blue, @gray].pack("EEEE")
  end

  def self._load(obj)
    Tone.new(*obj.unpack("EEEE"))
  end

end
