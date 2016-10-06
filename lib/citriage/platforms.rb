class Platforms
  @platforms = ['linux', 'windows', 'cross-platform', 'cloud', 'netdev']

  def self.get
    @platforms
  end
end
