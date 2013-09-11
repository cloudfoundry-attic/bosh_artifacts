class Files::Gem < Struct.new(
  :build_version_number,
  :name,
  :version,
  :original,
  :logger,
)
                # gems/agent_client-1.5.0.pre.977.gem
  S3_FILE_FMT = %r{\Agems/(.+)-(.+)\.(\d+)\.gem\z}

  def self.from_s3_file_possibly(s3_file, logger)
    if s3_file.key =~ S3_FILE_FMT
      new($3, $1, "#{$2}.#{$3}", s3_file, logger)
    end
  end

  def human_description
    "#{name} #{version}"
  end

  def original_name
    original.key
  end

  def original_short_name
    original_name.split("/").last
  end
end
