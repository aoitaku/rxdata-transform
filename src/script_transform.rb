class ScriptTransform

  include Enumerable

  INVALID_CHARS = %r{(\\|/|:|\*|\?|"|<|>|\|)}

  def initialize(scripts={})
    @scripts = scripts
  end

  def index
    @scripts.map {|id, (name, file, script)| file }
  end

  def each
    @scripts.each(&proc)
  end

  def to_h
    @scripts
  end

  def self.apply(rxdata)
    self.new(rxdata.map {|id, name, script|
      name.force_encoding('UTF-8')
      name   = '!' if name.empty?
      file   = name + '#' + id.to_s
      script = Zlib::Inflate.inflate(script)
      [id, [name, file, script]]
    }.to_h)
  end

  def to_rxdata
    @scripts.map do |id, (name, file, script)|
      name = '' if name == ?!
      script = Zlib::Deflate.deflate(script)
      [id, name, script]
    end
  end

  def self.normalize_filename(name)
    name.gsub(INVALID_CHARS) {|char| '{U+%04X}' % char.ord }
  end

end
