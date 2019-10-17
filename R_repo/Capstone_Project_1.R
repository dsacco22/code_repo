# First attempt at this

# Connecting to the database

library("odbc")
library("DBI")
library("RPostgreSQL")
library("ggplot2")
library("plotly")

##### Creating the connection ######

## Creating a variable for the password
pw <- {
  "ubaEYyxl3UimQCGa4S1e8yvlZmkGRK"
}

## Creating a variable for the driver
drv <- dbDriver("PostgreSQL")


## Creating the connection variable
conn <- dbConnect(drv, dbname="capstonedba",
                  host="capstone-db.c9mqkx12zppw.us-east-1.rds.amazonaws.com",
                  port=5432, user="capstonedba",
                  password = pw)

## Removing the password variable
rm(pw)


## Checking to see if the table exists in our connection
dbExistsTable(conn, "loans2")


##### Querying the Database for Basic Stuff ####

## Creating a basic query for the database
df_postgres <- dbGetQuery(conn, "SELECT * FROM loans2")
data <- data.frame(df_postgres)

data2 <- data.frame(data$back)

## Printing the query
head(df_postgres)


#### ggplot2 Graphing ####
p <-  ggplot(data, aes(x = ltv, y = loan_multiplier < 1.3)) +
  geom_point(aes(color=factor(proptype))) +
  theme_dark() +
  geom_hline(yintercept=1.3)


p

filter_test <- data[data$loan_multiplier < 1.3, ]