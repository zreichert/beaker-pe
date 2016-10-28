# Generates an OptionsHash of preset values for Beaker options relating to PE
#
# @return [OptionsHash] The supported arguments in an OptionsHash
def pe_presets
  h = Beaker::Options::OptionsHash.new
  h.merge({
    :disable_analytics => true,
  })
end
