class RootController < ApplicationController
  def show
    @collection_type = params[:type]
    @file_collection_presenter = \
      FileCollectionPresenter.new(Rails.logger)
  end
end
