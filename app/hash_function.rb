require 'gmp'

class HashFunction
  MULTIPLY_CONSTANT = 7
  A_SEED = 5234
  B_SEED = 7744

  def initialize(range_size:, id:)
    @i = id
    @M = GMP::Z.new(range_size - 1)

    loop do
      @p = (@M * MULTIPLY_CONSTANT).nextprime
      break if @p.probab_prime? == 2 # means confirm prime
      @p.nextprime!
    end

    a_ran = GMP::RandState.new(A_SEED)
    @i.times { a_ran.urandomm(@p) } # advance i times
    @a = a_ran.urandomm(@p)

    b_ran = GMP::RandState.new(A_SEED)
    @i.times { a_ran.urandomm(@p) } # advance i times
    @b = b_ran.urandomm(@p)
  end

  def hash(num)
    if num < 0 || num > @M
      raise "num (#{num}) should be in [0, #{@M}]"
    end

    (@a * num + @b).fmod(@p).fmod(@M)
  end
end
