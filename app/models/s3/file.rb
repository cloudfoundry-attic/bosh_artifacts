class S3::File
  attr_reader :key, :size

  def initialize(key, size, logger)
    @key = key
    @size = size
    @logger = logger
  end
end
