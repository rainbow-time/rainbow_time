# sync orders with trakt
class RainbowTime::OrderSpider
  def initialize(client, orders_list_name:, processed_list_name:, with_auth:)
    @client = client
    @with_auth = with_auth
    @orders_list_name = orders_list_name
    @processed_list_name = processed_list_name
  end

    # don't let trakt_api change data in this hash
  def with_auth
    @with_auth.clone
  end

  def load_control_lists
    all_lists = @client.user.lists(**with_auth)
    @orders_list = all_lists.find {|l| l.name == @orders_list_name}
    @processed_list = all_lists.find {|l| l.name == @processed_list_name}
  end

  def load_or_create_control_lists
    load_control_lists
    return if @orders_list && @processed_list

    if @orders_list.nil?
      @client.lists.add(name: @orders_list_name, privacy: 'private', **with_auth)
    end

    if @processed_list.nil?
      @client.lists.add(name: @processed_list_name, privacy: 'private', **with_auth)
    end
    load_control_lists
  end

  def run
    load_or_create_control_lists
    @orders_list = client.user.list(slug: @orders_list.slug, **with_auth)
    @processed_list = client.user.list(slug: @processed_list.slug, **with_auth)

    @orders_list.items.each do |trakt_list_item|
      trakt_order_item = RainbowTime::TraktOrderItem.new(trakt_list_item)
      add_order_if_missing(trakt_list_item)
    end

    unsynced_orders = RainbowTime::Orders.where(trakt_state_synced: false)
    unsynced_orders.each {|order| sync_to_trakt(order)}

  end

  def add_order_if_missing(trakt_order)
    find_existing_order(trakt_order)
  end

  def sync_to_trakt(order)
  end
end