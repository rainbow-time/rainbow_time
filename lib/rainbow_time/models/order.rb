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
  # skip_type_auto_validation :trakt_state
  # skip_type_auto_validation :state

  # def validate
    # super
    # validates_schema_types(keys - [:state])
  # end

  # subset(:with_state_new, :state => 0)

  # def state=(s)
  #   i = STATES.index(s)
  #   if i
  #     super(i)
  #   else
  #     self.db.log_each("invalid state '#{s}' for ")
  #   end
  # end

  # def state
  #   STATES[super]
  # end

  def state?(s)
    state == s
  end
end