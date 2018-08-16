class ApplicationServices
  def self.call(*args)
    self.new(*args).call
  end
end
