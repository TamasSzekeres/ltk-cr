require "../enums/size_policy"

module Ltk
  struct SizePolicies
    property horizontal : SizePolicy
    property vertical : SizePolicy

    EXPANDING = new(SizePolicy::Expanding, SizePolicy::Expanding)

    def initialize(@horizontal : SizePolicy = SizePolicy::Expanding,
                   @vertical : SizePolicy = SizePolicy::Expanding)
    end
  end
end
