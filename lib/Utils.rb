class Hash
  def strip_empty!
    delete_if { |k, v| v.empty? }
  end
end

class String
  def replace_whitespace(replace)
    gsub("\s", replace)
  end
end
