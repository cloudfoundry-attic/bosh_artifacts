class ApiController < ApplicationController
  def latest_stemcell
    logger = Rails.logger
    file_collection_presenter = FileCollectionPresenter.new(logger)

    files = file_collection_presenter.build_version_collection('stemcells').latest(1)[0].file_collection.to_a
    files = files.select {|s| s['name'] == params['name']} if params['name']
    files = files.select {|s| s['cloud_name'] == params['cloud_name']} if params['cloud_name']
    files = files.select {|s| s['infrastructure_name'] == params['infrastructure_name']} if params['infrastructure_name']
    files = files.select {|s| s['os_name'] == params['os_name']} if params['os_name']
    files = files.select {|s| s['os_version'] == params['os_version']} if params['os_version']
    files = files.select {|s| s['agent_type'] == params['agent_type']} if params['agent_type']
    render json: {
      results: files.map do |f|
        f.to_h.reject{|k,_| [:original, :logger].include? k}.merge(url: file_collection_presenter.linker('stemcells').url_for_file(f))
      end
    }
  end

  def latest_release
    logger = Rails.logger
    file_collection_presenter = FileCollectionPresenter.new(logger)

    files = file_collection_presenter.build_version_collection('releases').latest(1)[0].file_collection.to_a
    files = files.select {|s| s['name'] == params['name']} if params['name']
    render json: {
      results: files.map do |f|
        f.to_h.reject{|k,_| [:original, :logger].include? k}.merge(url: file_collection_presenter.linker('releases').url_for_file(f))
      end
    }
  end
end
