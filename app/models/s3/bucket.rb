class S3::Bucket
  attr_reader :url, :files

  def self.bosh_jenkins_artifacts(logger)
    url     = "https://s3.amazonaws.com/bosh-jenkins-artifacts"
    fetcher = S3::BucketUrlFetcher.new(url, logger)
    parser  = S3::BucketXmlParser.new(url, fetcher.fetch, logger)
    parser.parse
  end

  def self.bosh_jenkins_gems(logger)
    url     = "https://s3.amazonaws.com/bosh-jenkins-gems"
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
