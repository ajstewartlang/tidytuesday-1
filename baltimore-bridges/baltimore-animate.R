library(tidyverse)
library(maps)
library(ggmap)

#read in data
url <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2018-11-27/baltimore_bridges.csv'
full_bridges <- read_csv(url)

#clean up responsible agency
table(full_bridges$responsibility) #check for agencies with high counts
agency_list <- c('State Highway Agency','County Highway Agency','State Toll Authority',
                 'City or Municipal Highway Agency')

full_bridges$responsibility_short <- ifelse(full_bridges$responsibility %in% agency_list, 
                                            full_bridges$responsibility,
                                            'Other')

#counties in bridge dataset
bridge_counties <- c('anne arundel','baltimore city','baltimore','carroll',
                     'harford','howard')

#get county level boundaries, subset for maryland
counties <- map_data("county")
bmore_area <- counties %>%
  subset(subregion %in% bridge_counties & region == 'maryland')

ggplot() +
  geom_bar(data=full_bridges,aes(x=bridge_condition))


ggplot() +
  geom_polygon(data = bmore_area,aes(fill=NULL,x=long,y=lat,group=group)) +
  geom_path(data=bmore_area,aes(x=long,y=lat,group=group),color='white',size=0.1) +
  geom_point(data=subset(full_bridges,bridge_condition=='Poor'),
             alpha=0.5,
             aes(x=long,y=lat,colour=factor(responsibility_short),size=avg_daily_traffic)) +
  transition_time(yr_built) +
  coord_equal() +
  theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.text=element_text(size=8)
  )
  # labs(title='Con',
  #      color='Responsible Agency',
  #      size='Vehicles Per Day')





