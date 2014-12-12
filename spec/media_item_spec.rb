require_relative 'spec_helper.rb'

describe 'MediaItem' do
  it 'saves movie with right type' do
    item = RainbowTime::Movie.new(title: 'My Movie', year: 1999, trakt_url: 'http://blah.blah', imdb_id: '123imdb')
    item.slug = 'my-movie'
    item.save

    item = RainbowTime::Movie['my-movie']
    expect(item.type).to eq 1
  end

  it 'serializes show specification' do
    ss = RainbowTime::ShowSpecification.new({1 => {:episodes => [1, 2]}})
    item = RainbowTime::Show.new(show_specification: ss, title: 'My Show', year: 1999, trakt_url: 'http://blah.blah', tvdb_id: '123tvdb')
    item.slug = 'my-show'
    item.save

    loaded_item = RainbowTime::Show['my-show']
    expect(loaded_item.show_specification.seasons[1]).to eq({episodes: [1, 2]})
    expect(loaded_item.show_specification.seasons).to eq item.show_specification.seasons
  end
end