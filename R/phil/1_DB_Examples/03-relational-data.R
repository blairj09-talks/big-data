# Connect to Postgres
library(DBI)
library(RSQLite)

#wont work
db <- dbConnect(RPostgres::Postgres(), user, pass, ...)

# Connect to MySQL
#wont work
db <- dbConnect(RMySQL::MySQL(), user, pass, ...)

# Connect to SQLite
# will work by set WD
db <- dbConnect(RSQLite::SQLite(), dbname = "data/database.sqlite")

# Import data from SQLite
dbListTables(db)
dbGetQuery(db, "SELECT * FROM packages")
data <- dbGetQuery(db, "SELECT * FROM packages")#craft query
#dplyr would remove the need to do sql specific queries
#higher level lanague not require to craft sql spefici statements

# Disconnect
dbDisconnect(db)