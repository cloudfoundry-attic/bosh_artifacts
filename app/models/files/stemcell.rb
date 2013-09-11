class Files::Stemcell < Struct.new(
  :build_version_number,
  :name,
  :cloud_name,
  :infrastructure_name,
  :os_name,
  :original,
  :logger,
)
                # bosh-stemcell/aws/bosh-stemcell-891-aws-xen-ubuntu.tgz
                # micro-bosh-stemcell/aws/light-micro-bosh-stemcell-891-aws-xen-ubuntu.tgz
  S3_FILE_FMT = %r{\A[\w-]+/\w+/([\w-]+)-stemcell-(\d+)-(\w+)-(\w+)-(\w+)\.tgz\z}

  def self.from_s3_file_possibly(s3_file, logger)
    puts [s3_file.key, s3_file.key =~ S3_FILE_FMT].inspect
    if s3_file.key =~ S3_FILE_FMT
      new($2, $1, $3, $4, $5, s3_file, logger)
    end
  end

  def human_description
    "#{name} (#{cloud_name} #{infrastructure_name} #{os_name})"
  end

  def original_name
    original.key
  end

  def original_short_name
    original_name.split("/").last
  end
end
