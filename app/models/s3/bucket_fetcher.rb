class S3::BucketFetcher
  class FetchError < StandardError; end

  def initialize(bucket_url, logger)
    @bucket_url = bucket_url
    @logger = logger
  end

  def fetch_all
    @logger.info("s3_bucket_fetcher.#{__method__} url=#{@bucket_url}")

    next_url = @bucket_url
    bucket_pages = []

    while next_url
      fetcher = S3::BucketUrlFetcher.new(next_url, @logger)

      parser = S3::BucketPageXmlParser.new(@bucket_url, fetcher.fetch, @logger)
      bucket_page = parser.parse

      bucket_pages << bucket_page
      next_url = bucket_page.next_page_url
    end

    S3::Bucket.new(@bucket_url, bucket_pages.map(&:files).flatten, @logger)

  rescue Exception => e
    @logger.error("s3_bucket_fetcher.#{__method__}.error e=#{e.inspect} backtrace=#{e.backtrace.join("\n")}")
    raise FetchError, e.inspect
  end
end
