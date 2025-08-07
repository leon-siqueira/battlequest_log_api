class BaseService
  def initialize(**kwargs)
  end

  def self.call(**kwargs)
    new(**kwargs).call
  end

  def call
    run
  end

  private

  def run
    raise NotImplementedError, "Subclasses must implement the run method"
  end
end
