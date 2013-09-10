class FileCollectionPresenter
  def initialize(logger)
    @logger = logger
  end

  def build_version_collection(type)
    file_collection = \
      FileCollection.send("for_s3_#{type}", bucket, @logger)
    BuildVersionCollection.new(file_collection, @logger)
  end

  def latest_gems_build_version
    file_collection = \
      FileCollection.for_s3_gems(bucket, @logger)
    BuildVersionCollection.new(
      file_collection, @logger).latest
  end

  def latest_release_build_version
    file_collection = \
      FileCollection.for_s3_releases(bucket, @logger)
    BuildVersionCollection.new(
      file_collection, @logger).latest
  end

  def latest_stemcell_build_version
    file_collection = \
      FileCollection.for_s3_stemcells(bucket, @logger)
    BuildVersionCollection.new(
      file_collection, @logger).latest
  end

  def linker
    @linker ||= S3::BucketLinker.new(bucket)
  end

  private

  def bucket
    @bucket ||= S3::Bucket.bosh_ci_pipeline(@logger)
  end
end