require 'gmp'

# This function hashes numbers to [0, range_size]. You can set the ID to
# tweak the parameters.
class HashFunction
  MULTIPLY_CONSTANT = 7
  A_SEED = 5234
  B_SEED = 7744

  def initialize(range_size:, id:)
    @i = id
    @m = GMP::Z.new(range_size - 1)

    loop do
      @p = (@m * MULTIPLY_CONSTANT).nextprime
      break if @p.probab_prime? == 2 # means confirm prime
      @p.nextprime!
    end
  end

  def hash(num)
    (@a * num + @b).fmod(@p).fmod(@m).to_i
  end

  private def initialize_a_and_b
    a_ran = GMP::RandState.new(A_SEED)
    @i.times { a_ran.urandomm(@p) } # advance i times
    @a = a_ran.urandomm(@p)

    b_ran = GMP::RandState.new(B_SEED)
    @i.times { a_ran.urandomm(@p) } # advance i times
    @b = b_ran.urandomm(@p)
  end
end
