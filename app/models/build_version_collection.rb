require "semi_semantic/version"

class BuildVersionCollection
  include Enumerable

  def initialize(file_collection, logger)
    @file_collection = file_collection
    @logger = logger
  end

  delegate :each, to: :build_versions

  def sorted
    sort_by { |bv| SemiSemantic::Version.parse(bv.number) }.reverse
  end

  def latest(*args)
    sorted.first(*args)
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
