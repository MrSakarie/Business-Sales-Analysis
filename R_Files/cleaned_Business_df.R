library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
cleaning_df <- read.csv("C:\\Users\\Sakarie-Durba\\Desktop\\R Language\\R Projects\\Business_Project\\Business_Transactions.csv")

#Marking Empty,space and NA into real missing value
cleaning_df <- read.csv("C:\\Users\\Sakarie-Durba\\Desktop\\R Language\\R Projects\\Business_Project\\Business_Transactions.csv", na.strings = c("","NA"))

#checking the unique values inside the variables
cleaning_df %>% 
  summarise(
    across(
      c(product,category,payment_method,city), ~list(unique(.))
    )
  )

#checking the number of missing feilds
nrow(cleaning_df)
colSums(is.na(cleaning_df))
colMeans(is.na(cleaning_df))*100

#Removing the Empty Rows
cleaning_df <- cleaning_df %>% 
  drop_na(transaction_date)

#filling missing Rows into Numeric Values
#step1_convert into numeric
cleaning_df <- cleaning_df %>% 
  mutate(
    across(
      c(quantity,amount),
      ~as.numeric(.)
    )
  )
#step2_filling the na(numeric) into median value
cleaning_df <- cleaning_df %>%
  mutate(
    across(
      c(quantity, amount),
      ~ replace_na(., median(., na.rm = TRUE))
    )
  )


#Filling missing values into Character
cleaning_df <- cleaning_df %>% 
  mutate(
    across(
      c(payment_method,city),
      ~ifelse(is.na(.), "unkown" ,.)
    )
  )

#Formating the text into same type
cleaning_df <- cleaning_df %>% 
  mutate(
    across(
      c(
        product,category,payment_method,city
      ),
      ~tolower(trimws(.))
    )
  )

#Renaming values inside the variables
cleaning_df <- cleaning_df %>%
  mutate(
    payment_method = recode(payment_method,
                            "unkown" = "cheque"),
    city = recode(city,
                  "ny" = "new york",
                  "unkown"="washington")
  )


#Formating the Date in one single format
cleaning_df$transaction_date <- parse_date_time(cleaning_df$transaction_date,
                                orders = c("m/d/Y","Y-m-d","d-m-Y"))


boxplot(amount ~ customer_type, data = cleaning_df,
        main = "Amount Distribution by Customer Type",
        ylab = "Amount")


write.csv(cleaning_df,"C:\\Users\\Sakarie-Durba\\Desktop\\R Language\\R Projects\\Business_clean_df.csv", row.names = FALSE)
getwd()

