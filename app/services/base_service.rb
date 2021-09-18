class BaseService
  def self.perform(*args)
    new(*args).perform
  end

  def perform
    raise NotImplementedError
  end
end
