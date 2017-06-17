<<<<<<< HEAD
use work.my_arith_functions.all;

=======
>>>>>>> b5269eb7a9009e8583aa25f6804745188b2d496f
PACKAGE p4_carries_logic_network_functions IS
  FUNCTION bintree_blocks (
    n     : INTEGER;
    level : INTEGER
    )
    RETURN INTEGER;

  FUNCTION bintree_is_g (
    index : INTEGER
    )
    RETURN BOOLEAN;

  FUNCTION bintree_left (
    level : INTEGER;
    index : INTEGER
    )
    RETURN INTEGER;

  FUNCTION bintree_right (
    level : INTEGER;
    index : INTEGER
    )
    RETURN INTEGER;

  FUNCTION bintable_blocks (
    n          : INTEGER;
    carry_step : INTEGER
    )
    RETURN INTEGER;

  FUNCTION bintable_valid_block (
    level      : INTEGER;
    index      : INTEGER;
    carry_step : INTEGER
    )
    RETURN BOOLEAN;

  FUNCTION bintable_is_g (
    level      : INTEGER;
    index      : INTEGER;
    carry_step : INTEGER
    )
    RETURN BOOLEAN;

  FUNCTION bintable_left (
    carry_step : INTEGER;
    index      : INTEGER
    )
    RETURN INTEGER;

  FUNCTION bintable_right_offset (
    carry_step : INTEGER;
    level      : INTEGER;
    index      : INTEGER
    )
    RETURN INTEGER;

  FUNCTION bintable_right (
    carry_step : INTEGER;
    level      : INTEGER;
    index      : INTEGER
    )
    RETURN INTEGER;

END PACKAGE;

PACKAGE BODY p4_carries_logic_network_functions IS

  -- return # of blocks for the bintree level
  FUNCTION bintree_blocks (
    n     : INTEGER;
    level : INTEGER
    )
    RETURN INTEGER IS
  BEGIN
    RETURN 2**(log2int(n)-level);
  END FUNCTION;

  -- purpose: return if the block is a g block (bintree only)
  FUNCTION bintree_is_g (
    index : INTEGER
    )
    RETURN BOOLEAN IS
  BEGIN
    IF index = 1 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END FUNCTION;

-- purpose: return left index of bintree level
  FUNCTION bintree_left (
    level : INTEGER;
    index : INTEGER
    )
    RETURN INTEGER IS
  BEGIN
    RETURN index*2**level;
  END FUNCTION;

-- purpose: return right index of bintree level
  FUNCTION bintree_right (
    level : INTEGER;
    index : INTEGER
    )
    RETURN INTEGER IS
  BEGIN
    RETURN bintree_left(level, index)-2**(level-1);
  END FUNCTION;

-- purpose: return # of blocks for bintable level
  FUNCTION bintable_blocks (
    n          : INTEGER;
    carry_step : INTEGER
    )
    RETURN INTEGER IS
  BEGIN
    RETURN 2**(log2int(n)-log2int(carry_step));
  END FUNCTION;

  -- purpose: return if it's needed a block
  FUNCTION bintable_valid_block (
    level      : INTEGER;
    index      : INTEGER;
    carry_step : INTEGER
    )
    RETURN BOOLEAN IS
  BEGIN

    RETURN (index-1) MOD 2**(level-log2int(carry_step)) >= 2**(level-log2int(carry_step)-1);
  END FUNCTION;

-- purpose: return if the block is a g block (bintable only)
  FUNCTION bintable_is_g (
    level      : INTEGER;
    index      : INTEGER;
    carry_step : INTEGER
    )
    RETURN BOOLEAN IS
  BEGIN
    RETURN (index-1) < 2**(level-log2int(carry_step));
  END FUNCTION;

-- purpose: return left index of bintable level
  FUNCTION bintable_left (
    carry_step : INTEGER;
    index      : INTEGER
    )
    RETURN INTEGER IS
  BEGIN
    RETURN index*carry_step;
  END FUNCTION;

  -- purpose: return offset for right index of bintable level
  FUNCTION bintable_right_offset (
    carry_step : INTEGER;
    level      : INTEGER;
    index      : INTEGER
    )
    RETURN INTEGER IS
  BEGIN
    RETURN (index-1) MOD 2**(level-log2int(carry_step)-1)+1;
  END FUNCTION;

  -- purpose: return right index of bintable level
  FUNCTION bintable_right (
    carry_step : INTEGER;
    level      : INTEGER;
    index      : INTEGER
    )
    RETURN INTEGER IS
  BEGIN
    RETURN bintable_left(carry_step, index)-carry_step*bintable_right_offset(carry_step, level, index);
  END FUNCTION;
END PACKAGE BODY;
