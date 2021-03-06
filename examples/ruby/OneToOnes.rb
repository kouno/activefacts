require 'activefacts/api'

module ::OneToOnes

  class BoyID < AutoCounter
    value_type 
  end

  class GirlID < AutoCounter
    value_type 
  end

  class Boy
    identified_by :boy_id
    one_to_one :boy_id, :class => BoyID, :mandatory => true  # See BoyID.boy
  end

  class Girl
    identified_by :girl_id
    one_to_one :boy                             # See Boy.girl
    one_to_one :girl_id, :class => GirlID, :mandatory => true  # See GirlID.girl
  end

end
