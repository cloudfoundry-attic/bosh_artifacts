class Files::Stemcell < Struct.new(
  :build_version_number,
  :updated_at,
  :name,
  :cloud_name,
  :infrastructure_name,
  :os_name,
  :agent_type,
  :original,
  :logger,
)
                # bosh-stemcell/aws/bosh-stemcell-891-aws-xen-ubuntu.tgz
                # bosh-stemcell/aws/bosh-stemcell-2311-aws-xen-centos-go_agent.tgz
                # micro-bosh-stemcell/aws/light-micro-bosh-stemcell-891-aws-xen-ubuntu.tgz
  S3_FILE_FMT = %r{\A[\w-]+/\w+/([\w-]+)-stemcell-(\d+)-(\w+)-(\w+)-(\w+)(-(go_agent))?\.tgz\z}

  def self.from_s3_file_possibly(s3_file, logger)
    if s3_file.key =~ S3_FILE_FMT
      new($2, s3_file.last_modified, $1, $3, $4, $5, $7 || 'ruby_agent', s3_file, logger)
    end
  end

  def human_description
    "#{name} (#{cloud_name} #{infrastructure_name} #{os_name} #{agent_type})"
  end

  def original_name
    original.key
  end

  def original_short_name
    original_name.split("/").last
  end

  def sort_key
    agent_order = {
      'ruby_agent' => 0, 
      'go_agent' => 1
    }[agent_type] || 3

    [agent_order, name]
  end
end
