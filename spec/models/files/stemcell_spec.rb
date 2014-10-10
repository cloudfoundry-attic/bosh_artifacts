require "spec_helper"

describe Files::Stemcell do
  describe ".from_s3_file_possibly" do
    logger = Logger.new("/dev/null")

    examples = {
      "bosh-stemcell/aws/bosh-stemcell-891-aws-xen-ubuntu.tgz" => {
        version_number: "891",
        name: "bosh",
        cloud_name: "aws",
        infrastructure_name: "xen",
        os_name: "ubuntu",
        os_version: "lucid",
        agent_type: "ruby_agent",
      },
      
      "bosh-stemcell/aws/bosh-stemcell-2311-aws-xen-centos-go_agent.tgz" => {
        version_number: "2311",
        name: "bosh",
        cloud_name: "aws",
        infrastructure_name: "xen",
        os_name: "centos",
        os_version: nil,
        agent_type: "go_agent",
      },

      "bosh-stemcell/aws/bosh-stemcell-2446-aws-xen-ubuntu-lucid-go_agent.tgz" => {
        version_number: "2446",
        name: "bosh",
        cloud_name: "aws",
        infrastructure_name: "xen",
        os_name: "ubuntu",
        os_version: "lucid",
        agent_type: "go_agent",
      },

      "micro-bosh-stemcell/aws/light-micro-bosh-stemcell-891-aws-xen-ubuntu.tgz" => {
        version_number: "891",
        name: "light-micro-bosh",
        cloud_name: "aws",
        infrastructure_name: "xen",
        os_name: "ubuntu",
        os_version: "lucid",
        agent_type: "ruby_agent",
      },

      "micro-bosh-stemcell/warden/bosh-stemcell-56-warden-boshlite-ubuntu-lucid-go_agent.tgz" => {
        version_number: "56",
        name: "bosh",
        cloud_name: "warden",
        infrastructure_name: "boshlite",
        os_name: "ubuntu",
        os_version: "lucid",
        agent_type: "go_agent",
      },

      "bosh-stemcell/aws/light-bosh-stemcell-2579-aws-xen-centos.tgz" => {
        version_number: "2579",
        name: "light-bosh",
        cloud_name: "aws",
        infrastructure_name: "xen",
        os_name: "centos",
        os_version: nil,
        agent_type: "ruby_agent",
      },

      "bosh-stemcell/aws/light-bosh-stemcell-2579-aws-xen-centos-go_agent.tgz" => {
        version_number: "2579",
        name: "light-bosh",
        cloud_name: "aws",
        infrastructure_name: "xen",
        os_name: "centos",
        os_version: nil,
        agent_type: "go_agent",
      },
      
      "bosh-stemcell/aws/light-bosh-stemcell-2579.1-aws-xen-centos-go_agent.tgz" => {
        version_number: "2579.1",
        name: "light-bosh",
        cloud_name: "aws",
        infrastructure_name: "xen",
        os_name: "centos",
        os_version: nil,
        agent_type: "go_agent",
      },

      "bosh-stemcell/aws/light-bosh-stemcell-2579.1-aws-xen-hvm-centos-go_agent.tgz" => {
        version_number: "2579.1",
        name: "light-bosh",
        cloud_name: "aws",
        infrastructure_name: "xen-hvm",
        os_name: "centos",
        os_version: nil,
        agent_type: "go_agent",
      },

      "bosh-stemcell/aws/light-bosh-stemcell-2579.1-aws-xen-hvm-ubuntu-trusty-go_agent.tgz" => {
        version_number: "2579.1",
        name: "light-bosh",
        cloud_name: "aws",
        infrastructure_name: "xen-hvm",
        os_name: "ubuntu",
        os_version: "trusty",
        agent_type: "go_agent",
      }
    }

    examples.each do |path, expected|
      it "correctly interprets '#{path}'" do
        s3_file = S3::File.new(path, 100, 'fake-etag', Time.now, logger)

        expected = Files::Stemcell.new(
          expected[:version_number],
          s3_file.last_modified,
          expected[:name],
          expected[:cloud_name],
          expected[:infrastructure_name],
          expected[:os_name],
          expected[:os_version],
          expected[:agent_type],
          s3_file,
          logger,
        )
      
        actual = described_class.from_s3_file_possibly(s3_file, logger)

        expect(actual).to(eq(expected))
      end
    end
  end

  describe '#e_tag' do
    logger = Logger.new("/dev/null")

    let(:s3_file) do
      S3::File.new(
        'bosh-stemcell/aws/bosh-stemcell-891-aws-xen-ubuntu.tgz',
        100,
        'fake-etag',
        Time.now,
        logger,
      )
    end

    let(:stemcell) { described_class.from_s3_file_possibly(s3_file, logger) }

    it 'exposes the e_tag of its S3 file' do
      expect(stemcell.e_tag).to eq('fake-etag')
    end
  end
end
