class FileCollectionsController < ApplicationController
  def index
    @collection_type = params[:type]
    @file_collection_presenter = \
      FileCollectionPresenter.new(Rails.logger)
  end
end
