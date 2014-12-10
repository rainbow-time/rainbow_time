module Kernel
  def mash(object = {})
    case object
    when Hash
      Hashie::Mash.new(object)
    when Array
      object.map {|e| mash(e)}
    else
      object
    end
  end
end

class Time
  def self.timestamp
    self.now.strftime("%F %T")
  end
end
