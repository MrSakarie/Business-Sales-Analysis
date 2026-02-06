library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(readr)
Visual_df <- read.csv("C:\\Users\\Sakarie-Durba\\Desktop\\R Language\\R Projects\\Business_Project\\Analysing_df.csv")
#Q1. How is total revenue changing over time?
#Step1_Convert real date format
Visual_df <- Visual_df %>%
  mutate(transaction_date = as.Date(paste0(transaction_date, "-01")))

#Step2_aggregate you data
monthly_df <- Visual_df %>%
  group_by(transaction_date) %>%
  summarise(total_amount = sum(amount), .groups = "drop") %>%
  arrange(desc(total_amount))

#Step3_visualize you data
ggplot(monthly_df, aes(x=transaction_date, y=total_amount)) +
  geom_line(
    color = "#2C7FB8",
    linewidth = 1.2
  ) +
  geom_point(
    color = "red",
    size = 1.5
  ) +
  labs(
    title = "Monthly Transaction Trend",
    x = "Month",
    y = "Amount"
  ) +
  theme_classic(base_size = 10)

#Q2. Which products generate the highest total revenue?
product_revenue <- Visual_df %>% 
  group_by(product) %>% 
  summarise(Total_revenue=sum(amount, na.rm = TRUE)) %>% 
  arrange(desc(Total_revenue))

ggplot(product_revenue,
       aes(x = reorder(product, Total_revenue),
           y = Total_revenue)) +
  geom_col(fill="steelblue") +
  coord_flip() +
  labs(
    title = "Total Revenue by Product",
    x = "Product",
    y = "Total Revenue"
  ) +
  theme_classic(base_size = 15)

#Q3. Which product categories contribute most to overall sales?
category <- Visual_df %>% 
  group_by(category) %>% 
  summarise(Total = sum(amount, na.rm = TRUE)) %>% 
  arrange(desc(Total)) %>% 
  mutate(
    percent = Total / sum(Total),
    label = paste0(category, "\n", round(percent * 100, 1), "%")
  )

ggplot(category, aes(x = "", y = Total, fill = category)) +
  geom_col(width = 1) +
  coord_polar(theta = "y") +
  geom_text(aes(label = label),
            position = position_stack(vjust = 0.5),
            size = 5) +
  labs(
    title = "Category Contribution to Total Sales"
  ) +
  theme_void()

#Q4. How does revenue differ by customer type (Retail, Wholesale, Online)?
customer_type <- Visual_df %>% 
  group_by(customer_type) %>% 
  summarise(Total=sum(amount,na.rm = TRUE)) %>% 
  arrange(desc(Total)) %>% 
  mutate(
    percent = Total / sum(Total),
    label = paste0(customer_type, "\n", round(percent * 100, 1), "%")
  )

ggplot(customer_type, aes(x = "", y = Total, fill = customer_type)) +
  geom_col(width = 1) +
  coord_polar(theta = "y") +
  geom_text(aes(label = label),
            position = position_stack(vjust = 0.5),
            size = 3.5,
            color="white") +
  labs(
    title = "Customer Types"
  ) +
  theme_void()

#Q5. Which cities generate the highest revenue?
city <- Visual_df %>% 
  group_by(city) %>% 
  summarise(Total=sum(amount, na.rm = TRUE)) %>% 
  arrange(desc(Total)) %>% 
  mutate(
    percent = Total / sum(Total),
    label = paste0(city, "\n", round(percent * 100, 1), "%")
  )

ggplot(city,
       aes(x = reorder(city, Total),
           y = Total)) +
  geom_col(fill="steelblue") +
  coord_flip() +
  labs(
    title = "Customer Distribution By City",
    x = "city",
    y = "Total Revenue"
  ) +
  theme_classic(base_size = 15)


#Q6. Who are the top-performing sales representatives by total revenue?
sales_rep <- Visual_df %>% 
  group_by(sales_rep) %>% 
  summarise(Top_per=sum(amount, na.rm = TRUE)) %>% 
  arrange(desc(Top_per))

ggplot(sales_rep,
       aes(x = reorder(sales_rep, Top_per),
           y = Top_per)) +
  geom_col(fill="steelblue") +
  coord_flip() +
  labs(
    title = "Total Revenue by Sales perfomance",
    x = "sales person",
    y = "Total Revenue"
  ) +
  theme_classic(base_size = 15)


#Q7. What payment methods are most commonly used, and how much revenue does each generate?
payment_method <- Visual_df %>% 
  group_by(payment_method) %>% 
  summarise(Revenue=sum(amount, na.rm = TRUE)) %>% 
  arrange(desc(Revenue))

ggplot(payment_method,
       aes(x = reorder(payment_method, Revenue),
           y = Revenue)) +
  geom_col(fill="steelblue") +
  coord_flip() +
  labs(
    title = "Most Usable Patment System",
    x = "Payment",
    y = "Total Revenue"
  ) +
  theme_classic(base_size = 15)


#Q8. How does sales volume (quantity sold) vary across products?
sales_vol <- Visual_df %>% 
  group_by(product) %>% 
  summarise(quantity_sold=sum(quantity, na.rm = TRUE)) %>% 
  arrange(desc(quantity_sold)) 
  

ggplot(sales_vol,
       aes(x = reorder(product, quantity_sold),
           y = quantity_sold)) +
  geom_col(fill="steelblue") +
  coord_flip() +
  labs(
    title = "Most Quantity Sold",
    x = "Quantity",
    y = "Total Revenue"
  ) +
  theme_classic(base_size = 15)

#Q9. What is the average transaction value by customer type?
Avr_customer <- Visual_df %>% 
  group_by(customer_type) %>% 
  summarise(Average=mean(amount, na.rm=TRUE)) %>% 
  arrange(desc(Average)) %>% 
  mutate(
    percent = Average / sum(Average),
    label = paste0(customer_type, "\n", round(percent * 100, 1), "%")
  )

ggplot(Avr_customer, aes(x = "", y = Average, fill = customer_type)) +
  geom_col(width = 1) +
  coord_polar(theta = "y") +
  geom_text(aes(label = label),
            position = position_stack(vjust = 0.5),
            size = 3.5,
            color="white") +
  labs(
    title = "Average transaction value"
  ) +
  theme_void()

#Q10. How evenly is revenue distributed among sales representatives
Distribution <- Visual_df %>% 
  group_by(sales_rep) %>% 
  summarise(TotalRevenue = sum(amount, na.rm = TRUE)) %>%
  arrange(desc(TotalRevenue)) %>% 
  mutate(
    percent = TotalRevenue / sum(TotalRevenue),
    label = paste0(sales_rep, "\n", round(percent * 100, 1), "%")
  )

ggplot(Distribution, aes(x = "", y = TotalRevenue, fill = sales_rep)) +
  geom_col(width = 1) +
  coord_polar(theta = "y") +
  geom_text(aes(label = label),
            position = position_stack(vjust = 0.5),
            size = 3.5,
            color="white") +
  labs(
    title = "Revenue distributed among salese"
  ) +
  theme_void()

write.csv(Visual_df, "C:\\Users\\Sakarie-Durba\\Desktop\\R Language\\R Projects\\Business_Project\\Visual_df.csv")





