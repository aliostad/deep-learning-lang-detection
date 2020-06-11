begin
  require 'chemistry_paradise'
rescue LoadError; end

class DiamondShell

  # ========================================================================= #
  # === calculate
  #
  # Calculate a number via this method.
  # Usage example:
  #   calculate 5+5
  # ========================================================================= #
  def calculate(i)
    i = i.flatten.join(' ') if i.is_a? Array
    # First, sanitize the input data.
    case i[-1,1] # The last character.
    when '+','-','/'
      i[-1,1] == ''
    end
    if i.size > 2
      result = eval(i)
      e result
    end
  end

  # ========================================================================= #
  # === calculcate_molecular_weight
  #
  # Use this to calculate the molecular weight.
  # ========================================================================= #
  def calculcate_molecular_weight(i = 'Na2')
    if i.is_a? Array
      i.each {|entry| calculcate_molecular_weight(entry) }
    else
      e '|fancy|'+i+'|_|: '+StdChemistry.calculcate_molecular_weight(i).to_s
    end
  end

  # ========================================================================= #
  # === calculate_n_seconds
  #
  # To test this method, do:
  #   calculate_n_seconds 01:05
  # ========================================================================= #
  def calculate_n_seconds(i, be_verbose = true)
    if i.is_a? Array
      i.each {|entry| calculate_n_seconds(entry) }
    else
      splitted = i.split(':')
      n_minutes = splitted[0]
      n_seconds = splitted[1].to_i + n_minutes.to_i * 60
      e i+' is '+sfancy(n_seconds.to_s)+' seconds.' if be_verbose
      return n_seconds
    end
  end

end