class FileCollection
  include Enumerable

  def self.for_s3_gems(bucket, logger)
    for_s3_files(bucket, Files::Gem, logger)
  end

  def self.for_s3_releases(bucket, logger)
    for_s3_files(bucket, Files::Release, logger)
  end

  def self.for_s3_stemcells(bucket, logger)
    for_s3_files(bucket, Files::Stemcell, logger)
  end

  def self.for_s3_files(bucket, file_class, logger)
    convert = ->(f){ file_class.from_s3_file_possibly(f, logger) }
    new(bucket.files.map(&convert).compact, logger)
  end

  def initialize(files, logger)
    @files = files
    @logger = logger
  end

  delegate :each, to: :@files
end
