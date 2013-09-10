class S3::BucketLinker
  def initialize(bucket)
    @bucket = bucket
  end

  def url_for_file(file)
    "#{@bucket.url}/#{file.original.key}"
  end

  def rubygems_source_for_gems(build_version)
    "#{@bucket.url}/#{build_version.number}/gems"
  end
end
