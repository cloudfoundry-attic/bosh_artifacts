class Files::Stemcell < Struct.new(
  :build_version_number,
  :updated_at,
  :name,
  :cloud_name,
  :infrastructure_name,
  :os_name,
  :os_version,
  :agent_type,
  :original,
  :logger,
)
  # bosh-stemcell/aws/bosh-stemcell-891-aws-xen-ubuntu.tgz
  # bosh-stemcell/aws/bosh-stemcell-2311-aws-xen-centos-go_agent.tgz
  # bosh-stemcell/aws/bosh-stemcell-2446-aws-xen-ubuntu-lucid-go_agent.tgz
  # micro-bosh-stemcell/aws/light-micro-bosh-stemcell-891-aws-xen-ubuntu.tgz
  S3_FILE_FMT = %r{
    \A
      [\w-]+/
        \w+/
          (?<name>[\w-]+)
          -stemcell
          -(?<ver_num>\d+)
          -(?<c_name>\w+)
          -(?<i_name>\w+)
          -(?<os_name>\w+)
          (?<os_version>-\w+)?
          (?<agent_type>-go_agent)?
          \.tgz
    \z
  }x

  def self.from_s3_file_possibly(s3_file, logger)
    if md = s3_file.key.match(S3_FILE_FMT)
      os_name    = md[:os_name]
      os_version = md[:os_version] ? md[:os_version][1..-1] : 'lucid'
      agent_type = md[:agent_type] ? md[:agent_type][1..-1] : 'ruby_agent'

      if os_version =~ /ruby|go|agent/
        if os_name == 'ubuntu'
          agent_type, os_version = os_version, 'lucid'
        else
          agent_type, os_version = os_version, nil
        end
      end

      new(
        md[:ver_num], 
        s3_file.last_modified, 
        md[:name], 
        md[:c_name], 
        md[:i_name], 
        os_name, 
        os_version, 
        agent_type, 
        s3_file, 
        logger,
      )
    end
  end

  def human_description
    "#{name} (#{cloud_name} #{infrastructure_name} #{os_name} #{os_version} #{agent_type})"
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
