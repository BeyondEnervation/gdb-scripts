define dump_2d_fortran
  #Dump a 2D Fortran array slice (column-major layout) to file
  set $rows = $arg1
  set $cols = $arg2
  set $ptr = $arg3
  set logging file dump_2d_fortran.txt
  set logging on
  printf "[\n"
  set $i = 0
  while ($i < $rows)
    printf "  ["
    set $j = 0
    while ($j < $cols)
      set $flat_index = $i + $j * $rows  # Column-major index
      printf "%g", $ptr[$flat_index]
      if ($j < $cols - 1)
        printf ", "
      end
      set $j = $j + 1
    end
    printf "],\n"
    set $i = $i + 1
  end
  printf "]\n"
  set logging off
end

define dump_1d
  #Dump a 1D array slice to a file
  set $start = $arg1
  set $len = $arg2
  set $ptr = $arg3
  set logging file dump_1d.txt
  set logging on
  printf "[\n"
  set $i = 0
  while ($i < $len)
    printf "  %g,\n", $ptr[$start + $i]
    set $i = $i + 1
  end
  printf "]\n"
  set logging off
end

define dump_2d
  #Dump a 2D array slice (row-major) to a file
  set $rows = $arg1
  set $cols = $arg2
  set $ptr = $arg3
  set logging file dump_2d.txt
  set logging on
  printf "[\n"
  set $i = 0
  while ($i < $rows)
    printf "  ["
    set $j = 0
    while ($j < $cols)
      printf "%g", $ptr[$i * $cols + $j]
      if ($j < $cols - 1)
        printf ", "
      end
      set $j = $j + 1
    end
    printf "],\n"
    set $i = $i + 1
  end
  printf "]\n"
  set logging off
end

define dump_2d_fortran_general
  #Dump a 2D slice from a 4D Fortran array (column-major).
  # Arguments:
  # $arg0 = d1 (size of dimension 1)
  # $arg1 = d2
  # $arg2 = d3
  # $arg3 = d4
  # $arg4 = slice_dim1 (1-based, dimension index to iterate along rows)
  # $arg5 = slice_dim2 (1-based, dimension index to iterate along columns)
  # $arg6 = base pointer (e.g. &arr(1,1,1,1))

  set $d1 = $arg0
  set $d2 = $arg1
  set $d3 = $arg2
  set $d4 = $arg3
  set $sdim1 = $arg4
  set $sdim2 = $arg5 
  set $ptr = $arg6
  # Determine size of slice dimensions
  if $sdim1 == 1
    set $s1_size = $d1
  else
    if $sdim1 == 2
      set $s1_size = $d2
    else
      if $sdim1 == 3
        set $s1_size = $d3
      else
        set $s1_size = $d4
      end
    end
  end

  if $sdim2 == 1
    set $s2_size = $d1
  else
    if $sdim2 == 2
      set $s2_size = $d2
    else
      if $sdim2 == 3
        set $s2_size = $d3
      else
        set $s2_size = $d4
      end
    end
  end

  # Logging setup
  set logging file dump_2d_general.txt
  set logging overwrite on
  set logging redirect on
  set logging enabled on

  printf "[\n"
  set $i = 1
  while ($i <= $s1_size)
    printf "  ["
    set $j = 1
    while ($j <= $s2_size)

      set $i1 = 1
      set $i2 = 1
      set $i3 = 1
      set $i4 = 1

      if $sdim1 == 1
        set $i1 = $i
      else
        if $sdim1 == 2
          set $i2 = $i
        else
          if $sdim1 == 3
            set $i3 = $i
          else
            set $i4 = $i
          end
        end
      end

      if $sdim2 == 1
        set $i1 = $j
      else
        if $sdim2 == 2
          set $i2 = $j
        else
          if $sdim2 == 3
            set $i3 = $j
          else
            set $i4 = $j
          end
        end
      end

      set $offset = ($i1 - 1) + ($i2 - 1)*$d1 + \
      ($i3 - 1)*$d1*$d2 + ($i4 - 1)*$d1*$d2*$d3
      set $idx = $offset
      printf "%g", *($ptr + $idx)
      if ($j < $s2_size)
        printf ", "
      end
      set $j = $j + 1
    end
    printf "],\n"
    set $i = $i + 1
  end
  printf "]\n"
  set logging off
end

