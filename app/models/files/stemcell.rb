class Files::Stemcell < Struct.new(
  :build_version_number,
  :name,
  :cloud_name,
  :infrastructure_name,
  :os_name,
  :original,
  :logger,
)
                # 975/bosh-stemcell/aws/bosh-stemcell-975-aws-xen-ubuntu.tgz
  S3_FILE_FMT = %r{\A(\d+)/bosh-stemcell/(\w+)/(\w+)-stemcell-\d+-\w+-(\w+)-(\w+).tgz\z}

  def self.from_s3_file_possibly(s3_file, logger)
    if s3_file.key =~ S3_FILE_FMT
      new($1, $3, $2, $4, $5, s3_file, logger)
    end
  end

  def human_description
    "#{cloud_name} #{infrastructure_name} #{os_name}"
  end

  def original_name
    original.key
  end
end
