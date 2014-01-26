class S3::File
  attr_reader :key, :size, :last_modified

  def initialize(key, size, last_modified, logger)
    @key = key
    @size = size
    @last_modified = last_modified
    @logger = logger
  end
end
