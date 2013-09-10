class S3::Bucket
  attr_reader :url, :files

  def self.bosh_ci_pipeline(logger)
    url     = "https://s3.amazonaws.com/bosh-ci-pipeline"
    fetcher = S3::BucketUrlFetcher.new(url, logger)
    parser  = S3::BucketXmlParser.new(url, fetcher.fetch, logger)
    parser.parse
  end

  def initialize(url, files, logger)
    @url = url
    @files = files
    @logger = logger
  end
end
