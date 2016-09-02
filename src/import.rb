module Rxdata

  class Importer

    def initialize(input, output='build')
      @input  = Pathname(input) + 'export'
      @output = Pathname(input) + output
      @output.mkdir unless @output.exist?
    end

    def import
      puts 'importing...'
      paths = Pathname.glob((@input + '*.json'))
      count = paths.size
      progress = ProgressBar.create(format: '%a |%b>>%i| %p%% %t', starting_at: 0, total: count, output: $stderr)
      paths.each_with_index do |path, i|
        progress.increment
        name = path.basename('.json')
        json = path.read(mode: 'r:utf-8')
        data = Oj.load(json)
        case name.to_s
        when 'Scripts'
          transform = ScriptTransform.new(data.map(&method(:import_script)).to_h)
          data = transform.to_rxdata
        when 'MapInfos'
          config_json = @input + name.sub_ext('.config.json')
          configs = Oj.load(config_json.read(mode: 'r:utf-8'))
          map_info = MapInfoTransform.new(data, configs)
          data = map_info.to_h
        end
        rxdata = @output + name.sub_ext(Rxdata::EXT)
        rxdata.write(Marshal.dump(data), mode: 'wb')
        rxdata.utime(path.atime, path.mtime)
      end
      puts
      puts 'import completed.'
    end

    def import_script(file)
      name, _, id = file.rpartition(?#)
      name = name.gsub(/\{U\+([\dA-F]{4})\}/) {|_| $1.to_i(16).chr("UTF-8") }
      script = @input + 'Scripts' + (ScriptTransform.normalize_filename(file) + '.rb')
      [id, [name, file, script.read]]
    end

  end
end
