class BaseQuery
  class << self
    def result(*args)
      new(*args).result
    end
  end
end
