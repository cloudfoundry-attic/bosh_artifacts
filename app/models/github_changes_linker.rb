class GithubChangesLinker
  def initialize(base_url)
    @base_url = base_url
  end

  def compare_url(build_version, previous_build_version)
    "#{@base_url}/compare/stable-#{previous_build_version.number}...stable-#{build_version.number}"
  end
end
