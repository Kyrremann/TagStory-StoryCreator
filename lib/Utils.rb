class Hash
  def strip_empty!
    delete_if { |k, v| v.empty? }
  end
end

class String
  def replace_whitespace(replace)
    gsub("\s", replace)
  end

  def is_uuid?
    is_uuid1? or is_uuid4?
  end

  def is_uuid1?
    self.length == 36 && (self =~ /^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$/i) == 0
  end

  def is_uuid4?
    self.length == 36 && self =~ /^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i
  end
end

def empty_s?(value)
  return (value.nil? or value.empty?)
end
