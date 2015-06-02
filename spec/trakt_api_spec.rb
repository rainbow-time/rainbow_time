require_relative 'spec_helper.rb'

describe TraktApi do
  before do
    auth = RainbowTime.config.auth
    @api = RainbowTime::TraktApi.new(auth.api_key, auth.username, auth.password)
  end

  around(:each) do |example|
  #   puts "NEFORE"
  #   puts example.description
  #   puts "done==="
  #   puts example.full_description
  #   puts "done---"
  #   exit
  VCR.use_cassette {example.run}
  end

  it 'gets user list' do
    response = @api.user_lists
    # p response
    # pp response
    # puts "===="
    # pp response.code
    # puts '---'
    # pp JSON.parse(response.body)
    # pp response.effective_url
    # pp response.request.method

    # p response.return_code
  end
end