class MapInfoTransform

  attr_reader :infos, :configs

  def initialize(infos={}, configs={})
    @infos = infos
    @configs = configs
  end

  def to_h
    @infos.zip(@configs).map {|(id, info), (_, config)|
      config.each {|key, value| info.instance_variable_set(:"@#{key}", value) }
      [id, info]
    }.to_h
  end

  def self.apply(rxdata)
    infos = rxdata.sort_by(&:first).map {|id, info|
      ['^#%X' % id, [id, info.to_hash]]
    }.to_h
    configs = infos.map {|sig, (id, info)|
      [sig, [id, %w(expanded scroll_x scroll_y).map {|ex| [ex, info.delete(ex)]}.to_h]]
    }.to_h
    self.new(infos, configs)
  end

end
