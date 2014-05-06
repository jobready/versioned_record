module ActiveRecord
  class Base
    def self.versioned?
      false
    end

    def versioned?
      self.class.versioned?
    end
  end
end


