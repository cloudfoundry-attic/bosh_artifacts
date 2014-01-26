require "active_support/core_ext/hash/conversions"

class S3::BucketXmlParser
  def initialize(bucket_url, xml, logger)
    @bucket_url = bucket_url
    @xml = xml
    @logger = logger
  end

  def parse
    hash  = parse_bucket_contents(@xml)
    files = build_files(hash)
    build_bucket(files)
  end

  private

  def parse_bucket_contents(contents)
    Hash.from_xml(contents)
  end

  def build_files(hash)
    hash["ListBucketResult"]["Contents"].map do |content|
      S3::File.new(
        content["Key"],
        content["Size"],
        Time.parse(content["LastModified"]),
        @logger,
      )
    end
  end

  def build_bucket(files)
    S3::Bucket.new(@bucket_url, files, @logger)
  end
end
