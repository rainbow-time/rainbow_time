# errors.add(:show_subset, "no seasons or episodes specified") if show_subset.blank? || show_subset.seasons.blank?
class RainbowTime::Order < Sequel::Model
  many_to_one :media_item
  many_to_many :torrents
end