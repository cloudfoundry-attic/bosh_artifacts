class BuildVersionCollection
  include Enumerable

  def initialize(file_collection, logger)
    @file_collection = file_collection
    @logger = logger
  end

  delegate :each, to: :build_versions

  def sorted
    sort_by(&:number).reverse
  end

  def latest
    sorted.first
  end

  private

  def build_versions
    @build_versions ||= begin
      @file_collection.group_by(&:build_version_number).map do |bvn, files|
        BuildVersion.new(bvn, FileCollection.new(files, @logger))
      end
    end
  end
end
