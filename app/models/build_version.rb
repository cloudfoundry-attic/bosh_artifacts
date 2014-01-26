class BuildVersion < Struct.new(:number, :file_collection)
  def published_at
    if f = file_collection.first
      f.updated_at
    end
  end
end
