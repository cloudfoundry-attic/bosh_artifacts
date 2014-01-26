class Files::Release < Struct.new(
  :build_version_number,
  :updated_at,
  :name,
  :original,
  :logger,
)
                # release/bosh-977.tgz
  S3_FILE_FMT = %r{\Arelease/(\w+)-(\d+)\.tgz\z}

  def self.from_s3_file_possibly(s3_file, logger)
    logger.debug([s3_file.key, s3_file.key =~ S3_FILE_FMT])
    if s3_file.key =~ S3_FILE_FMT
      new($2, s3_file.last_modified, $1, s3_file, logger)
    end
  end

  def human_description
    "#{name}"
  end

  def original_name
    original.key
  end

  def original_short_name
    original_name.split("/").last
  end
end
