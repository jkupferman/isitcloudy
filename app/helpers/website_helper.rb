module WebsiteHelper
  SUPPORTED_CLOUDS = [:ec2, :rackspace, :gogrid, :joyent, :linode]

  EC2_REGEX = /AMAZON-EC2-[\d]+/
  RACKSPACE_REGEX = /RSCP-NET-[\d]+/
  GOGRID_REGEX = /GOGRID-BLK[\d]+/
  JOYENT_REGEX = /NETWO1924-ARIN/
  LINODE_REGEX = /LINODE-US/

  def on_cloud?
    on_ec2? || on_rackspace? || on_gogrid? || on_joyent? || on_linode?
  end

  def on_ec2?
    ! EC2_REGEX.match(self.pretty_whois).nil?
  end

  def on_rackspace?
    ! RACKSPACE_REGEX.match(self.pretty_whois).nil?
  end

  def on_gogrid?
    ! GOGRID_REGEX.match(self.pretty_whois).nil?
  end

  def on_joyent?
    ! JOYENT_REGEX.match(self.pretty_whois).nil?
  end

  def on_linode?
    ! LINODE_REGEX.match(self.pretty_whois).nil?
  end
end
