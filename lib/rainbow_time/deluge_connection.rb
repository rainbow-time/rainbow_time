require 'deluge'

class DelugeConnection
  attr_reader :settings
  attr_reader :client, :core

  def connect
    opts = RainbowTime.settings.deluge.connection

    info "Connecting to deluged #{opts.login}@#{opts.host}:#{opts.port}..."
    @client = Deluge::Rpc::Client.new(opts.clone)
    @client.connect
    @core = client.core

    info "Connected to deluged #{client.daemon.info}! Auth level = #{client.auth_level}"
  end

  def configure_labels_plugin
    managed_label = RainbowTime.settings.deluge.managed_label

    enabled_plugins = core.get_enabled_plugins || [] # returns nil if array is empty
    unless enabled_plugins.include?('Label')
      info "Enabling plugin 'Label' and reconnecting to Deluge"
      core.enable_plugin('Label')
      connect # reload RPC methods
    end

    existing_labels = client.label.get_labels || []

    unless existing_labels.include?(managed_label)
      client.label.add(managed_label)
    end
  end
end