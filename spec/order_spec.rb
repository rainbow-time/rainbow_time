require_relative 'spec_helper.rb'

describe 'Order' do
  it "sets valid state" do
    order1 = build(:order)

    expect(order1.state).to eq :new

    order1.save
    expect(order1.state).to eq :new

    order1.reload
    expect(order1.state).to eq :new
    expect(order1.state?(:new)).to eq true
    expect(order1.state?(:specified)).to eq false
    expect(RainbowTime::Order.state_is_new.all).to eq([order1])
    expect(RainbowTime::Order.state_is_specified.all).to eq([])


    order1.state = :specified
    expect(order1.state).to eq :specified
    expect(order1.state?(:new)).to eq false

    order1.save
    order1.reload
    expect(order1.state?(:specified)).to eq true
    expect(RainbowTime::Order.state_is_specified.all).to eq([order1])
  end

  it "has state dataset method" do
    order1 = create(:order)
    order2 = create(:order, state: :specified)

    expect(RainbowTime::Order.by_state(:new).all).to eq([order1])
    expect(RainbowTime::Order.by_state(:specified).all).to eq([order2])
  end
end