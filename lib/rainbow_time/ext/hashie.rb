module Hashie::Extensions::Dash::PsychSerialization
  def encode_with(coder)
    self.each { |key, val|
      coder.map[key] = val
    }
  end

  def init_with(coder)
    coder.map.each {|key, val|
      self[key] = val
    }
  end
end
