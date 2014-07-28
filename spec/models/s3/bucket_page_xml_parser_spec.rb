require 'spec_helper'

describe S3::BucketPageXmlParser do
  describe '#parse' do

xml = <<EOF
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

    let(:bucket) { double('bucket') }
    let(:logger) { double('logger') }

    it 'does stuff' do
      allow(S3::BucketPage).to receive(:new)

      expect(S3::File).to receive(:new).with(
                            'release/bosh-1644.tgz',
                            '129786667',
                            '302e3c1f30d571efc150c37b7442aaea',
                            Time.parse('2013-12-25T07:01:23.000Z'),
                            logger)

      expect(S3::File).to receive(:new).with(
                            'release/bosh-1645.tgz',
                            '129788667',
                            'a03e3c1f30d571efc150c37b7442aaea',
                            Time.parse('2014-12-25T07:01:23.000Z'),
                            logger)

      parser = described_class.new(bucket, xml, logger)
      parser.parse

    end
  end
end