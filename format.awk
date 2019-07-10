#!/usr/bin/awk -f

BEGIN{
   row_number = 1
   max_row_size = 0
   regex = "^(---)"
   regex2 = "( record[(]s[)] )(selected.)$"

   offset = 1
}

{
   # initially, the fixed width of each column is the length of the column's name itself
   # column names are expected at NR==2
   if ( NR==2 ) {
      for( i=1; i<=NF; i++ ) {
         result_set[ row_number, i ] = $i
         max_column_size[i] = length( $i )
      }
      row_number = row_number + 1
   }

   # Next, look for dashes (---) below the column names
   # Use their length as the max possible column's size in the final data set
   if ( match($1,regex) ) {
      for( i=1; i<=NF; i++ ) {
         max_possible_col_size[i] = length($i)
      }
      number_of_cols = length(max_possible_col_size)
      next
   }

   if ( match($0, regex2) ) {
      records_selected = $0
      next
   }
   
   for( i=1; i<=number_of_cols; i++ ) {

      # extract column value, including right/left spaces
      # the delimiter for this is stored in max_possible_col_size[i]
      full_column[i] = substr($0, offset, max_possible_col_size[i])

      # remove spaces
      reduced_column = full_column[i]
      gsub(/[ \t]+$/, "", reduced_column) # remove trailling spaces
      gsub(/^[ \t]+/, "", reduced_column) # remove leading spaces
      column_size[i] = length(reduced_column)

      result_set[ row_number, i ] = reduced_column

      # keep track of max column size
      if((column_size[i] > max_column_size[i])){
         max_column_size[i] = column_size[i]
      }

      # keep track of max row size
      if(NF > max_row_size){
         max_row_size = NF
      }

     # before advancing to the next col, move offset
     offset = offset + max_possible_col_size[i] + 1

   }
   offset = 1
   row_number = row_number + 1

}

END{

  printf("Number of columns: %d \n", length(max_column_size))
  printf("Column sizes: ")

  for(i=1; i<=number_of_cols; i++) {
     printf("%d ", max_column_size[i])
  }
  print ""

  # at this point, all rows are stored in "result_set",
  # but the minimum/reduced sizes (after striping spaces)
  # the final stage formats each column with a fixed width (max_column_size)

  # loop row
  for ( i=2; i<=row_number; i++){                # skip first empty row ( i=2 )
         # loop column
     for (j=1; j<=number_of_cols; j++) {
                printf("%*s|", max_column_size[j], result_set[i, j])     # dynamic print format
          }
          print ""
  }
  print records_selected
}

