module Oj

  module Hashable

    def to_hash
      { "^o" => self.class.to_s }.update(instance_variables.sort.map {|iv|
        [iv.to_s.gsub(/^@/,''), instance_variable_get(iv)]
      }.to_h)
    end

  end
end
