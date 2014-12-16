require_relative 'spec_helper.rb'

describe 'MediaItem' do
  it 'saves movie with right type' do
    movie = create(:movie)

    movie.reload
    expect(movie.type).to eq 0
  end

  it 'serializes show specification' do
    item = create(:show)
    item.show_specification = RainbowTime::ShowSpecification.new({1 => {:episodes => [1, 2]}})
    item.save

    item.reload
    expect(item.show_specification).to be_kind_of(RainbowTime::ShowSpecification)
    expect(item.show_specification.seasons[1]).to eq({episodes: [1, 2]})
  end
end