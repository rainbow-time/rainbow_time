require_relative 'spec_helper.rb'

describe 'Data Model' do
  it 'has associations' do
      item = RainbowTime::Movie.create(slug: 'my-movie', title: 'My Movie', year: 1999, trakt_url: 'http://blah.blah', imdb_id: '123imdb')
      order1 = RainbowTime::Order.create()
      order2 = RainbowTime::Order.create()


      item.add_order(order1)
      order2.media_item = item
      order2.save


      torrent1 = RainbowTime::Torrent.create
      torrent2 = RainbowTime::Torrent.create

      order1.add_torrent torrent1
      torrent2.add_order order1
      torrent1.add_order order2


      item.reload
      expect(item.orders).to eq([order1, order2])

      order1.reload
      expect(order1.torrents).to eq([torrent1, torrent2])

      torrent1.reload
      torrent2.reload
      expect(torrent1.orders).to eq([order1, order2])
      expect(torrent2.orders).to eq([order1])
  end
end
