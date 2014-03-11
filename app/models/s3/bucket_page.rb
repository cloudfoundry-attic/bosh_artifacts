class S3::BucketPage
  attr_reader :files

  def initialize(bucket_url, files, max_keys, is_truncated, logger)
    @bucket_url = bucket_url
    @is_truncated = is_truncated
    @files = files
    @max_keys = max_keys
    @logger = logger
  end

  def next_page_url
    if is_truncated?
      "#{@bucket_url}?max-keys=#{@max_keys}&marker=#{@files.last.key}"
    end
  end

  def is_truncated?
    !!@is_truncated
  end
end
