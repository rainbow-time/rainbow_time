# errors.add(:show_subset, "no seasons or episodes specified") if show_subset.blank? || show_subset.seasons.blank?
class RainbowTime::Order < Sequel::Model
  many_to_one :media_item
  many_to_many :torrents

  # Integer   :type, null: false, default: 0
  # Integer   :season, null: true, default: nil
  # Integer   :episode, null: true, default: nil
  # Integer   :trakt_state, null: false, default: 0
  # TrueClass :trakt_state_synced, default: true   # Boolean
  # Integer   :state, null: false, default: 0

  enum :state, [:new, :specified, :resolved, :downloaded]
  enum :trakt_state, [:new, :processed]

  def self.order_types
    [:movie, :show]
  end

  def self.order_types(type)
    order_types.index(type.to_sym)
  end

  def state?(s)
    state == s
  end
end