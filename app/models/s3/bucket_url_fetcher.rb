require "net/http"

class S3::BucketUrlFetcher
  class FetchError < StandardError; end

  def initialize(bucket_url, logger)
    @bucket_url = bucket_url
    @logger = logger
  end

  def fetch
    @logger.info("s3_bucket_url_fetcher.#{__method__} url=#{@bucket_url}")

    uri = URI.parse(@bucket_url)
    req = Net::HTTP::Get.new(uri.request_uri)

    options = {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }

    time_with_logger do
      res = Net::HTTP.start(uri.host, uri.port, options) { |http| http.request(req) }
      res.body
    end

  rescue Exception => e
    @logger.error("s3_bucket_url_fetcher.#{__method__}.error e=#{e.inspect}")
    raise FetchError, e.inspect
  end

  private

  def time_with_logger(&blk)
    t1 = Time.now
    @logger.info("s3_bucket_url_fetcher.#{__method__} url=#{@bucket_url} started_at=#{t1}")

    blk.call
  ensure
    t2 = Time.now
    @logger.info("s3_bucket_url_fetcher.#{__method__} url=#{@bucket_url} finished_at=#{t2} delta=#{t2.to_f - t1.to_f}s")
  end
end
