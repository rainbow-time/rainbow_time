require_relative 'spec_helper.rb'

# http://blog.teamtreehouse.com/an-introduction-to-rspec
# http://blog.jasonkim.ca/blog/2014/02/04/basic-testing-setup-with-rspec-and-factorygirl/
describe 'Data model' do
  context "classes" do
    let(:show1) { create(:show)}
    let(:show2) { create(:show)}

    let(:order1) { create(:order, media_item: show1) }
    let(:order2) { create(:order, media_item: show1) }

    let(:torrent1) { create(:torrent) }
    let(:torrent2) { create(:torrent) }

    it 'have order-media item associations' do
      show1.reload
      expect(show1.orders).to eq([order1, order2])

      order2.reload
      expect(order2.media_item).to eq(show1)
    end

    it 'have order-torrent associations' do
      order1.add_torrent torrent1
      torrent2.add_order order1
      torrent1.add_order order2

      order1.reload
      expect(order1.torrents).to eq([torrent1, torrent2])

      torrent1.reload
      torrent2.reload
      expect(torrent1.orders).to eq([order1, order2])
      expect(torrent2.orders).to eq([order1])
    end
  end
end
