load_data <- function(csv_path)
{
  require(tidyverse)
  
  
  strain_data <- read_csv('library_strains.csv') %>%
    select('Ver5.0 position','Systematic ID') %>%
    separate('Ver5.0 position', into = c('Version','Plate','Well')) %>%
    mutate(Plate = str_extract(Plate, pattern = '[:digit:]{2}')) %>%
    mutate(Plate = as.numeric(Plate), Well = as.numeric(Well))
 
  
  data <- read_csv(csv_path) %>% 
    mutate(File_name = basename(Metadata_FileLocation)) %>%
    separate(File_name, into = c('Well','Well_n','Picture','Z_axis','Time','Type'), sep = '--') %>%
    filter(Metadata_QCFlag != 1)
  
  plate_n <- get_plate_number(data$Metadata_Plate_Name)
  
  my_plate <- filter(strain_data, Plate == plate_n)
  
  final_data <- left_join(data,my_plate, by = c( 'Metadata_WellNumber' = 'Well'))
  return(final_data)

}

get_plate_number <- function(plate_name_vector){
  require(tidyverse)
  plate_n  <- str_extract(plate_name_vector,pattern = '[:digit:]' ) %>%
    unique()
  if(length(plate_n) > 1)
  {
    print('Check the data, the plate name is not consistent')
  }else{
    return(plate_n)
  }
  
}