library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
Analysing_df <- read.csv("C:\\Users\\Sakarie-Durba\\Desktop\\R Language\\R Projects\\Business_Project\\Business_clean_df.csv")

#Q1. How is total revenue changing over time?

Analysing_df <- Analysing_df %>% 
  mutate(transaction_date = as.Date(transaction_date))

Analysing_df$transaction_date <- format(Analysing_df$transaction_date, "%Y-%m")

Monthly_amount <- aggregate(amount~transaction_date, data = Analysing_df,sum)

#Q2. Which products generate the highest total revenue?
product_revenue <- Analysing_df %>% 
  group_by(product) %>% 
  summarise(Total_revenue=sum(amount, na.rm = TRUE)) %>% 
  arrange(desc(Total_revenue))

percentage_ <- product_revenue %>% 
  mutate(percentage = Total_revenue / sum(Total_revenue) * 100)

#Q3. Which product categories contribute most to overall sales?
category <- Visual_df %>% 
  group_by(category) %>% 
  summarise(Total = sum(amount, na.rm = TRUE)) %>% 
  arrange(desc(Total)) %>% 
  mutate(
    percent = Total / sum(Total),
    label = paste0(category, "\n", round(percent * 100, 1), "%")
  )

#Q4. How does revenue differ by customer type (Retail, Wholesale, Online)?
customer_type <- Analysing_df %>% 
  group_by(customer_type) %>% 
  summarise(Total=sum(amount,na.rm = TRUE)) %>% 
  arrange(desc(Total)) %>% 
  mutate(
    percent = Total / sum(Total),
    label = paste0(customer_type, "\n", round(percent * 100, 1), "%")
  )


#Q5. Which cities generate the highest revenue?
city <- Analysing_df %>% 
  group_by(city) %>% 
  summarise(Total=sum(amount, na.rm = TRUE)) %>% 
  arrange(desc(Total)) %>% 
  mutate(
    percent = Total / sum(Total),
    label = paste0(city, "\n", round(percent * 100, 1), "%")
  )


#Q6. Who are the top-performing sales representatives by total revenue?
sales_rep <- Analysing_df %>% 
  group_by(sales_rep) %>% 
  summarise(Top_per=sum(amount, na.rm = TRUE)) %>% 
  arrange(desc(Top_per))

#Q7. What payment methods are most commonly used, and how much revenue does each generate?
payment_method <- Analysing_df %>% 
  group_by(payment_method) %>% 
  summarise(Revenue=sum(amount, na.rm = TRUE)) %>% 
  arrange(desc(Revenue))

#Q8. How does sales volume (quantity sold) vary across products?
sales_vol <- Analysing_df %>% 
  group_by(product) %>% 
  summarise(quantity_sold=sum(quantity, na.rm = TRUE)) %>% 
  arrange(desc(quantity_sold))

#Q9. Are there seasonal patterns in sales across months or years?
#Seasonality <- Analysing_df %>%
  #mutate(month = format(as.Date(transaction_date), "%m")) %>%
  #group_by(month) %>%
  #summarise(TotalRevenue = sum(amount, na.rm = TRUE)) %>% 
  #arrange(TotalRevenue)


#Q10. What is the average transaction value by customer type?
Avr_customer <- Analysing_df %>% 
  group_by(customer_type) %>% 
  summarise(Average=mean(amount, na.rm=TRUE)) %>% 
  arrange(desc(Average))
  
#Q11. Which products are frequently sold in larger quantities?
frequently <- Analysing_df %>% 
  group_by(product) %>% 
  summarise(Large_Quantity=sum(quantity, na.rm = TRUE)) %>% 
  arrange(desc(Large_Quantity))

#Q12. How evenly is revenue distributed among sales representatives
Distribution <- Analysing_df %>% 
  group_by(sales_rep) %>% 
  summarise(TotalRevenue = sum(amount, na.rm = TRUE)) %>%
  mutate(share = TotalRevenue / sum(TotalRevenue) * 100) %>% 
  arrange(desc(TotalRevenue))


write.csv(Analysing_df, "C:\\Users\\Sakarie-Durba\\Desktop\\R Language\\R Projects\\Business_Project\\Analysing_df.csv")





