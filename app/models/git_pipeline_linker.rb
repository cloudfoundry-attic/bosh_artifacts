class GitPipelineLinker
  def initialize(url, pipeline_name)
    @url = url
    @pipeline_name = pipeline_name
  end

  # Follows github url schema: earlier...latest
  def changes_url(build_version, previous_build_version)
    "#{@url}/pipelines/#{@pipeline_name}/versions/#{previous_build_version.number}...#{build_version.number}"
  end
end
