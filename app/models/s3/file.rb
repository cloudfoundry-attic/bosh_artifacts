class S3::File
  attr_reader :key, :size, :e_tag, :last_modified

  def initialize(key, size, e_tag, last_modified, logger)
    @key = key
    @size = size
    @e_tag = e_tag
    @last_modified = last_modified
    @logger = logger
  end
end
