require "active_support/core_ext/hash/conversions"

class S3::BucketPageXmlParser
  def initialize(bucket_url, xml, logger)
    @bucket_url = bucket_url
    @xml = xml
    @logger = logger
  end

=begin
  Expected XML:

  <ListBucketResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
    <Name>bosh-jenkins-artifacts</Name>
    <Prefix/>
    <Marker>release/bosh-1639.tgz</Marker>
    <MaxKeys>1000</MaxKeys>
    <IsTruncated>false</IsTruncated>
    <Contents>
      <Key>release/bosh-1644.tgz</Key>
      <LastModified>2013-12-25T07:01:23.000Z</LastModified>
      <ETag>"302e3c1f30d571efc150c37b7442aaea"</ETag>
      <Size>129786667</Size>
      <StorageClass>STANDARD</StorageClass>
    </Contents>
    ...
  </ListBucketResult>

  ListBucketResult.Marker is empty unless marker query param is specified.
=end

  def parse
    hash = Hash.from_xml(@xml)

    files = hash["ListBucketResult"]["Contents"].map do |content|
      S3::File.new(
        content["Key"],
        content["Size"],
        content["ETag"].gsub('"', ''),
        Time.parse(content["LastModified"]),
        @logger,
      )
    end

    max_keys = hash["ListBucketResult"]["MaxKeys"].to_i

    is_truncated = hash["ListBucketResult"]["IsTruncated"] == "true"

    S3::BucketPage.new(@bucket_url, files, max_keys, is_truncated, @logger)
  end
end
