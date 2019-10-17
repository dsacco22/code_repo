# Loading packages
library("shiny")
library("dplyr")
library("dbplyr")
library("pool")

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

## Querying the database ##
df_postgres <- dbGetQuery(conn, "SELECT * FROM loans2")
