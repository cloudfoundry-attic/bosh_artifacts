class Files::Release < Struct.new(
  :build_version_number,
  :name,
  :original,
  :logger,
)
                # 977/release/bosh-977.tgz
  S3_FILE_FMT = %r{\A(\d+)/release/(\w+)-\d+.tgz\z}

  def self.from_s3_file_possibly(s3_file, logger)
    if s3_file.key =~ S3_FILE_FMT
      new($1, $2, s3_file, logger)
    end
  end

  def human_description
    "#{name}"
  end

  def original_name
    original.key
  end
end
