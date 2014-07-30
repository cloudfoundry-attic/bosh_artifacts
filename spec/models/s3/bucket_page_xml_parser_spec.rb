require 'spec_helper'

describe S3::BucketPageXmlParser do
  subject { described_class.new(bucket_url, bucket_xml, logger) }
  let(:bucket_url) { 'fake-bucket-url' }
  let(:logger) { Logger.new('/dev/null') }

  let(:bucket_xml) { <<EOF }
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
  <Contents>
    <Key>release/bosh-1645.tgz</Key>
    <LastModified>2014-12-25T07:01:23.000Z</LastModified>
    <ETag>"a03e3c1f30d571efc150c37b7442aaea"</ETag>
    <Size>129788667</Size>
    <StorageClass>STANDARD</StorageClass>
  </Contents>
</ListBucketResult>
EOF

  describe '#parse' do
    it 'does stuff' do
      file1 = double('file1')
      file2 = double('file2')

      expect(S3::File).to receive(:new).with(
        'release/bosh-1644.tgz',
        '129786667',
        '302e3c1f30d571efc150c37b7442aaea',
        Time.parse('2013-12-25T07:01:23.000Z'),
        logger,
      ).and_return(file1)

      expect(S3::File).to receive(:new).with(
        'release/bosh-1645.tgz',
        '129788667',
        'a03e3c1f30d571efc150c37b7442aaea',
        Time.parse('2014-12-25T07:01:23.000Z'),
        logger,
      ).and_return(file2)

      bucket_page = double('bucket-page')

      allow(S3::BucketPage).to receive(:new).with(
        bucket_url,
        [file1, file2],
        1000,
        false,
        logger,
      ).and_return(bucket_page)

      expect(subject.parse).to eq(bucket_page)
    end
  end
end