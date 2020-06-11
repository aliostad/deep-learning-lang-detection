require_relative 'unary_gate'

# -1 -1 -1
class FalseGate < UnaryGate # !true (Contradiction)

  def calculate
    -1
  end

end unless defined?(FalseGate)

# -1 -1 0
class ShiftLeftGate < UnaryGate # !potfalse

  def calculate
    input == 1 ? 0 : -1
  end

end

# -1 -1 1
class AbsTrueGate < UnaryGate #  (Decoder)

  def calculate
    input == 1 ? 1 : -1
  end

end

# -1 0 -1
class UnBGate < UnaryGate

  def calculate
    input == 0 ? 0 : -1 # (input + 1) % 2 - 1
  end

end

# -1 0 0
class ClampDownGate < UnaryGate # Related to UnF and UnH

  def calculate
    input == -1 ? -1 : 0
  end

end

# -1 0 1
class IdentityGate < UnaryGate

  def calculate
    input
  end

end

# -1 1 -1
class UncertainGate < UnaryGate # !certain   (Decoder)

  def calculate
    input == 0 ? 1 : -1
  end

end

# -1 1 0
class UnDGate < UnaryGate # !wrapright

  def calculate
    input == -1 ? -1 : (input - 1).abs
  end

end

#-1 1 1
class PotTrueGate < UnaryGate

  def calculate
    input == -1 ? -1 : 1
  end

end

#0 -1 -1
class NshiftRIghtGate < UnaryGate

  def calculate
    input == -1 ? 0 : -1
  end

end

#0 -1 0
class UnFGate < UnaryGate # !unk   Related to ClampDown and UnH

  def calculate
    input == 0 ? -1 : 0
  end

end

# 0 -1 1
class UnGGate < UnaryGate # !unj

  def calculate
    input == 1 ? 1 : -((input + 1) % 2)
  end

end


# 0 0 -1
class UnHGate < UnaryGate # !uni Related to ClampDown and UnF

  def calculate
    input == 1 ? -1 : 0
  end

end

# 0 0 0
class PotentialGate < UnaryGate

  def calculate
    0
  end

end unless defined?(PotentialGate)

# 0 0 1
class ClampUpGate < UnaryGate # !unh

  def calculate
    input == 1 ? 1 : 0
  end

end

# 0 1 -1
class IncrementGate < UnaryGate # Wrap Left

  def calculate
    (input - 1) % 3 - 1
  end

end

# 0 1 0
class UnKGate < UnaryGate

  def calculate
    input == 0 ? 1 : 0 # (input + 1) % 2
  end

end

# 0 1 1
class ShiftRightGate < UnaryGate  # ProbablyTrue

  def calculate
    input == -1 ? 0 : 1
  end

end

# 1 -1 -1
class AbsFalseGate < UnaryGate # Negative threshold inverter    (Decoder)

  def calculate
    input == -1 ? 1 : -1  # !(input == -1)
  end

end

# 1 -1 0
class DecrementGate < UnaryGate # Wrap right

  def calculate
    input % 3 - 1
  end

end

# 1 -1 1
class CertainGate < UnaryGate # AbsoluteCertain  (Not absuncertain)

  def calculate
    input == 0 ? -1 : 1
  end

end


# 1 0 -1
class NotGate < UnaryGate

  def calculate
    -input
  end

end

# 1 0 0
class UnOGate < UnaryGate # !ClampDown

  def calculate
    input == -1 ? 1 : 0
  end

end

# 1 0 1
class UnPGate < UnaryGate

  def calculate
    input == 0 ? 0 : 1 # Opposite internal logic of UnO are they related? Also !unb
  end

end

# 1 1 -1
class PotFalseGate < UnaryGate # !abstrue or NabsTrue   (Positive Threshold Inverter)

  def calculate
    input == 1 ? -1 : 1 # !(a == 1)
  end

end

# 1 1 0
class NshiftLeftGate < UnaryGate # !shiftleft

  def calculate
    input == 1 ? 0 : 1
  end

end

class TrueGate < UnaryGate #!false  (Tautology)

  def calculate
    1
  end

end unless defined?(TrueGate)


