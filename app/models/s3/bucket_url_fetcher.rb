require "net/http"

class S3::BucketUrlFetcher
  class FetchError < StandardError; end

  def initialize(bucket_url, logger)
    @bucket_url = bucket_url
    @logger = logger
  end

  def fetch
    @logger.info("s3_bucket_fetcher.#{__method__} url=#{@bucket_url}")

    uri = URI.parse(@bucket_url)
    req = Net::HTTP::Get.new(uri.path)

    options = {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }
    res = Net::HTTP.start(uri.host, uri.port, options) { |http| http.request(req) }
    res.body
  rescue Exception => e
    @logger.error("s3_bucket_fetcher.#{__method__}.error e=#{e.inspect}")
    raise FetchError, e.inspect
  end
end
