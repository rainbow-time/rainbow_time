require_relative 'spec_helper.rb'

describe 'MediaItem' do
  it 'saves movie with right type' do
    item = RainbowTime::Movie.new(title: 'My Movie', year: 1999, trakt_url: 'http://blah.blah', imdb_id: '123imdb')
    item.slug = 'my-movie'
    item.save

    item = RainbowTime::Movie['my-movie']
    expect(item.type).to eq 1
  end
end