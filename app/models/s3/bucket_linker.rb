class S3::BucketLinker
  def initialize(bucket)
    @bucket = bucket
  end

  def url_for_file(file)
    "#{@bucket.url}/#{file.original.key}"
  end

  def rubygems_source_for_gems
    "#{@bucket.url}"
  end
end
