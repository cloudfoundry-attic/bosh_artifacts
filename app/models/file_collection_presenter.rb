class FileCollectionPresenter
  def initialize(logger)
    @logger = logger
  end

  def build_version_collection(type)
    bucket = bucket_for_type(type)
    file_collection = \
      FileCollection.send("for_s3_#{type}", bucket, @logger)
    BuildVersionCollection.new(file_collection, @logger)
  end

  def latest_build_version(type)
    build_version_collection(type).latest(2)
  end

  def linker(type)
    S3::BucketLinker.new(bucket_for_type(type))
  end

  def git_pipeline_linker
    GitPipelineLinker.new("http://git_pipeline.cfapps.io", "bosh")
  end

  private

  def bucket_for_type(type)
    type == "gems" ? gems_bucket : default_bucket
  end

  def gems_bucket
    @gems_bucket ||= S3::Bucket.bosh_jenkins_gems(@logger)
  end

  def default_bucket
    @default_bucket ||= S3::Bucket.bosh_jenkins_artifacts(@logger)
  end
end
