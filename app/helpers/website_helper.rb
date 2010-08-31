module WebsiteHelper

  class Cloud
    attr_accessor :name, :regex
    def initialize name, regex
      @name = name
      @regex = regex
    end
  end

   CLOUDS = {
     :ec2       => Cloud.new("Amazon EC2", /AMAZON-EC2-[\d]+/    ),
    :rackspace => Cloud.new("Rackspace",   /RS(CP|PC)-NET-[\d]+/ ),
     :gogrid    => Cloud.new("GoGrid",     /GOGRID-BLK[\d]+/     ),
     :joyent    => Cloud.new("Joyent",     /NETWO1924-ARIN/      ),
     :linode    => Cloud.new("Linode",     /LINODE-US/           )
   }

  def on_cloud?
    CLOUDS.each do |sym, cloud|
      return true if self.send("on_#{sym.to_s}?")
    end
    false
  end

  # Generate the on_? method for each cloud
  CLOUDS.each do |sym, cloud|
    define_method "on_#{sym}?".to_sym do |*args|
      cloud.regex =~ self.pretty_whois
    end
  end

  def on? cloud_name
    if CLOUDS.keys.include?(cloud_name)
      self.send("on_#{cloud_name.to_s}?")
    end
  end

  def cloud_name
    CLOUDS.each do |sym, cloud|
      return cloud.name if self.on? sym
    end

    nil
  end
end
