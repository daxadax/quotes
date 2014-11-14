module Support
  class FakeBackend

    def initialize
      @memories = Hash.new
      @next_uid = 0
    end

    def insert(object)
      object[:uid] = next_uid

      @memories[object[:uid]] = object
      object[:uid]
    end

    def get(uid)
      @memories[uid]
    end

    def all
      @memories.values
    end

    def update(object)
      @memories[object[:uid]] = object
      object[:uid]
    end

    def delete(uid)
      @memories.delete(uid)
    end

    private

    def next_uid
      @next_uid += 1
    end

  end
end
