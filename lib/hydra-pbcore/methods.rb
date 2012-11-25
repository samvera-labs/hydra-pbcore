module HydraPbcore::Methods

  def remove_node(type, index = 0)
    self.find_by_terms(type.to_sym).slice(index.to_i).remove
    self.dirty = true
  end

end