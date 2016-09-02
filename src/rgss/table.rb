class Table

  def initialize(data)
    @num_of_dimensions, @xsize, @ysize, @zsize, @num_of_elements, *@elements = *data
    if @num_of_dimensions > 1
      if @xsize > 1
        @elements = @elements.each_slice(@xsize).to_a
      else
        @elements = @elements.map{|element|[element]}
      end
    end
    if @num_of_dimensions > 2
      if @ysize > 1
        @elements = @elements.each_slice(@ysize).to_a
      else
        @elements = @elements.map{|element|[element]}
      end
    end
  end

  def _dump(limit)
    [@num_of_dimensions, @xsize, @ysize, @zsize, @num_of_elements, *@elements.flatten].pack("VVVVVv*")
  end

  def self._load(obj)
    Table.new(obj.unpack("VVVVVv*"))
  end

end
