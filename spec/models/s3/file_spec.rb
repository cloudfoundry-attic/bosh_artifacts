require 'spec_helper'

describe S3::File do
  let(:file){ S3::File.new('path', nil, 'etag_from_aws', Time.now, double('logger')) }

  describe '#e_tag' do
    it 'has the correct e_tag' do
      expect(file.e_tag).to eq('etag_from_aws')
    end
  end

end