#!/usr/bin/awk -f

BEGIN{
   total_rows = 0
   row_number = 1
   max_row_size = 0   
   regex = "^---" 
}

{
   if (match($1,regex)) {
      next
   }
   
   # loop once through all columns
   for( i=1; i<=NF; i++ ) {	  
	  # per row, save on an array the size of each column
      column_size[i] = length($i)
	  
	  # save the row in a multi-dimensional array (row x column) for later format
	  result_set[ row_number, i ] = $i
	  
      # keep track of max column size
	  if((column_size[i] > max_column_size[i])){
         max_column_size[i] = column_size[i]
      }		

	  # keep track of max row size
	  if(NF > max_row_size){
	     max_row_size = NF 
	  }
   }
   
   row_number = row_number + 1
}

END{
   printf("Max number of columns: %d \n", length(max_column_size))
   printf("Max size of each column: ")
   
   for( i in max_column_size ) {
      printf("%s ", max_column_size[i])
   }
   
   print ""
   
   # loop row
   for ( i=1; i<=row_number; i++){ 
      # loop column
      for (j=1; j<=max_row_size; j++) {
	     printf("%-*s ", max_column_size[j], result_set[i, j])
	  }
	  print ""
   }
}

