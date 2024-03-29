# Create An Oligos File For Demultiplexing Index Primers (eDNA)
# Conor O'Kane

# libraries
library(tidyverse)
library(readxl)


# The example provided for this script was performed with 6 total PCR plates.
# The first 5 plates were full, and the 6th was a partial plate that ranged from
# B5 to E12. Be sure to adjust parameters according to your own data.


#--------------------------------------------------
# FOR FULL PLATES
#--------------------------------------------------

# initialize an empty list to store the stacked data frames
stacked_plate_list <- list()

# number of sheets you want to do 
# (note: this will do the full sheets starting at 1 and up to this number, for 
# specific plates or partial plates see below)
sheets_number <- 5

# loop over each sheet, saving each cell name to a stacked list
for (i in 1:sheets_number) {
  # read the sheet
  plate <- read_excel("./PCR plate setup submission1.xlsx", # change to given file name
                      sheet = i, col_names = FALSE,
                      range = "B5:M12") # full plate, adjustments for partial plates can be done below
  
  # unlists and stores all names for each plate as single column
  stacked_plate_list[[paste0("plate", i, "_stacked")]] <- data.frame(sample_id = unlist(plate, use.names = FALSE))
}

# view list here
stacked_plate_list

# save stacked plates to global environment
list2env(stacked_plate_list, envir = .GlobalEnv)

# you will now have each plate saved as it's own object/list, named "plate#_stacked" up to
# the total number of plates that you selected


#--------------------------------------------------
# FOR PARTIAL PLATES
#--------------------------------------------------
# can skip if no partial plates

sheet_number_partial <- 6 # change to specific sheet number for the partial plate

# read the partial plate data from the given sheet
partial_plate <- read_excel("./PCR plate setup submission1.xlsx", # change to given file name
                            sheet = sheet_number_partial, 
                            col_names = FALSE,
                            range = "B5:E12") # adjust this range specifically for partial plate

# convert to data frame and unlist to a vector
partial_plate <- data.frame(Sample_ID = unlist(partial_plate, use.names = FALSE))

# this will likely give some empty cells, so remove those if necessary
tail(partial_plate) # check the end for empty values
partial_plate_filtered <- partial_plate[partial_plate$Sample_ID != "–", ] 

# name the variable based on the sheet number
assign(paste0("plate", sheet_number_partial, "_stacked"), partial_plate_filtered)

# convert to df (change plate # to your specific plate)
plate6_stacked <- data.frame(sample_id = plate6_stacked)

# if you have multiple partial plates, can then repeat this step to additional
# partial plates. Be sure to change the variable named of the stacked df to correspond
# to each plate number, then they should all be saved and ready for final step


#--------------------------------------------------
# ASSIGNING INDEX VALUES
#--------------------------------------------------

# forward and reverse primers, adjust if needed
forward_primer <- "ACTGGGATTAGATACCCC"
reverse_primer <- "TAGAACAGGCTCCTCTAG"

# total number of plates (adjust as needed)
total_plate_number <- 6 


#--------------
# add the i7 index primer to each plate list

# make i7 list
i7_primer_list <- read_excel("./Corrected eDNA metabarcoding genomic and index primers 112221.xlsx", 
                             sheet = 2, 
                             col_names = FALSE,
                             range = paste0("C2:C", total_plate_number + 1)) # accounts for specific # of plates

# add the i7 primer indices to each of the plate data frames
for (i in 1:total_plate_number) {
  # get each plate
  plate_df <- get(paste0("plate", i, "_stacked"))
  # add primer column 
  plate_df <- plate_df %>%
    mutate(forward_primer = i7_primer_list$...1[i])
  # assign forward primer to column name
  names(plate_df)[names(plate_df) == "forward_primer"] <- forward_primer
  # assign back to original name
  assign(paste0("plate", i, "_stacked"), plate_df)
}

# stacked plate lists should now include i7 column:
head(plate1_stacked) # can check all plates if you want

#--------------
# add the i5 index primer to each plate list

# make i5 primer list (will need to be adjusted to proper name, sheet and range if file changes)
i5_primer_list <- read_excel("./Corrected eDNA metabarcoding genomic and index primers 112221.xlsx", 
                             sheet = 3, 
                             col_names = FALSE,
                             range = "B2:B97")

# add the i5 primer indices to each of the plate data frames
for (i in 1:total_plate_number) {
  # get each plate
  plate_df <- get(paste0("plate", i, "_stacked"))
  # get number of rows to account for partial plate
  num_rows <- nrow(plate_df)
  # add primer column 
  plate_df <- plate_df %>%
    mutate(reverse_primer = i5_primer_list$...1[1:num_rows]) # this accounts for partial plate too
  # assign reverse primer to column name
  names(plate_df)[names(plate_df) == "reverse_primer"] <- reverse_primer
  # assign back to original name
  assign(paste0("plate", i, "_stacked"), plate_df)
}

# stacked plate lists should now include i5 column:
head(plate1_stacked) # can check all plates if you want

#--------------
# final data organization

# combine all samples into single dataframe
oligos_df <- bind_rows(plate1_stacked,
                       plate2_stacked,
                       plate3_stacked,
                       plate4_stacked,
                       plate5_stacked,
                       plate6_stacked) # add or remove plates depending on your data

# add primer and barcode indicator column
oligos_df <- oligos_df %>%
  mutate(primer = "BARCODE", .before = 1)

# reorganize order of the columns
oligos_df <- oligos_df[,c(1,3,4,2)]

# change sample_id header to specific gene region
colnames(oligos_df)[4] <- "12S"

# check data frame
head(oligos_df)


#-----------------
# write out file
write.table(oligos_df, 
            file = "oligos_df.txt", # can provide a specific directory/name, if wanted
            sep = "\t", # tab-delimited
            quote = FALSE, # no quotes added 
            row.names = FALSE, # row names are not kept
            col.names = TRUE) # column names are kept



