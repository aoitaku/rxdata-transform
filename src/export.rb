module Rxdata

  class Exporter

    def initialize(input, output='export')
      @input  = Pathname(input) + 'Data'
      @output = Pathname(input) + output
      @output.mkdir unless @output.exist?
      (@output + 'Scripts').mkdir unless (@output + 'Scripts').exist?
    end

    def export
      puts 'exporting...'
      paths = Pathname.glob((@input + ('*' + Rxdata::EXT)))
      count = paths.size
      progress = ProgressBar.create(format: '%a |%b>>%i| %p%% %t', starting_at: 0, total: count, output: $stderr)
      paths.each_with_index do |path, i|
        progress.increment
        name = path.basename(Rxdata::EXT)
        rxdata = Marshal.load(path.read(mode: 'rb'))
        case name.to_s
        when 'Scripts'
          transform = ScriptTransform.apply(rxdata)
          transform.each {|id, (name, file, script)| export_script(file, script) }
          rxdata = transform.index
        when 'MapInfos'
          map_info = MapInfoTransform.apply(rxdata)
          config_json = @output + name.sub_ext('.config.json')
          config_json.write(Oj.dump(map_info.configs), mode: 'w')
          rxdata = map_info.infos
        when /^Map\d+$/
          events = rxdata.instance_variable_get(:@events).sort_by(&:first).map {|key, value|
            ['^#%X' % key, [key, value]]
          }.to_h
          rxdata.instance_variable_set(:@events, events)
        else
        end
        json = @output + name.sub_ext('.json')
        json.write(Oj.dump(rxdata), mode: 'w')
        json.utime(path.atime, path.mtime)
      end
      puts
      puts 'export completed.'
    end

    def export_script(file, script)
      rb = @output + 'Scripts' + (ScriptTransform.normalize_filename(file) + '.rb')
      rb.write(script, mode: 'wb')
    end

  end
end
