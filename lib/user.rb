class User
  attr_reader :id, :name

  def initialize(user_hash)
    @id = user_hash["id"]
    @name = user_hash["name"]
  end

  def to_hash
    return {"id" => @id, "name" => @name}
  end
end