-- @block
SHOW DATABASES;
-- @block
USE bento_pos;
-- Add USER table
-- @block
CREATE TABLE USERS(
    user_id INT AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    role smallint NOT NULL,
    --Will be mapped
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    last_updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id)
);
-- @block
ALTER TABLE USER_ACCOUNT
MODIFY user_id INT UNSIGNED AUTO_INCREMENT;
-- Renaming my user to user_account
-- @block
RENAME TABLE USERS TO USER_ACCOUNT;
-- Whoops accidentally used reserved words
-- @block
ALTER TABLE USER_ACCOUNT
    RENAME COLUMN password TO user_password;
ALTER TABLE USER_ACCOUNT
    RENAME COLUMN role TO user_role;
-- Add CUSTOMER TABLE
-- @block
CREATE TABLE CUSTOMER(
    customer_id INT UNSIGNED AUTO_INCREMENT,
    user_ref INT UNSIGNED NOT NULL UNIQUE,
    -- 1:1 relationship
    -- Composite name 
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    -- Composite shipping address
    street VARCHAR(50),
    city VARCHAR(50),
    state_code CHAR(2),
    zipcode CHAR(5),
    -- Phone number
    phone_number VARCHAR(12),
    refunds_per_month TINYINT UNSIGNED,
    loyalty_points INT UNSIGNED,
    total_amount_spent INT UNSIGNED,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    last_updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(customer_id),
    FOREIGN KEY(user_ref) REFERENCES USER_ACCOUNT(user_id) ON DELETE RESTRICT
);
-- Create Payment Method Table
-- @block
CREATE TABLE PAYMENT_METHOD(
    payment_method_id INT UNSIGNED AUTO_INCREMENT,
    customer_ref INT UNSIGNED NOT NULL,
    payment_type TINYINT UNSIGNED NOT NULL,
    last_four CHAR(4),
    -- Can be null for paypal, apple pay
    exp_date CHAR(5),
    -- MM/DD
    -- composite billing address
    billing_street VARCHAR(50) NOT NULL,
    billing_city VARCHAR(50) NOT NULL,
    billing_state_code CHAR(2) NOT NULL,
    billing_zipcode CHAR(5) NOT NULL,
    -- name on card
    first_name VARCHAR(50) NOT NULL,
    middle_init CHAR(1),
    last_name VARCHAR(50) NOT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    last_updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(payment_method_id),
    FOREIGN KEY(customer_ref) REFERENCES CUSTOMER(customer_id) ON DELETE RESTRICT
);
-- Create Staff
-- @block
CREATE TABLE STAFF(
    staff_id INT UNSIGNED AUTO_INCREMENT,
    user_ref INT UNSIGNED NOT NULL,
    -- staff name
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(12) NOT NULL,
    hire_date date NOT NULL,
    salary INT UNSIGNED NOT NULL,
    created_by INT UNSIGNED NOT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_by INT UNSIGNED,
    last_updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(staff_id),
    FOREIGN KEY(user_ref) REFERENCES USER_ACCOUNT(user_id) ON DELETE RESTRICT,
    FOREIGN KEY(created_by) REFERENCES STAFF(staff_id) ON DELETE RESTRICT,
    FOREIGN KEY(updated_by) REFERENCES STAFF(staff_id) ON DELETE
    SET NULL
);
-- @block
ALTER TABLE STAFF
MODIFY user_ref INT UNSIGNED NOT NULL UNIQUE;
-- Create Promotion
-- @block
CREATE TABLE PROMOTION(
    promotion_id INT UNSIGNED AUTO_INCREMENT,
    promo_description VARCHAR(255) NOT NULL,
    promo_type TINYINT UNSIGNED NOT NULL,
    -- Mapping
    promo_code VARCHAR(50) NOT NULL UNIQUE,
    promo_exp_date date NOT NULL,
    created_by INT UNSIGNED NOT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_by INT UNSIGNED,
    last_updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(promotion_id),
    FOREIGN KEY(created_by) REFERENCES STAFF(staff_id) ON DELETE RESTRICT,
    FOREIGN KEY(updated_by) REFERENCES STAFF(staff_id) ON DELETE
    SET NULL
);
-- Create ORDER
-- @block
CREATE TABLE ORDERS(
    order_id INT UNSIGNED AUTO_INCREMENT,
    customer_ref INT UNSIGNED NOT NULL,
    order_date date NOT NULL,
    order_status TINYINT,
    delivery_date date,
    -- can be null for now (processing),
    unit_price int NOT NULL,
    tax int NOT NULL,
    discount int DEFAULT 0,
    notes VARCHAR(255),
    -- delivery instructions etc.
    refund_message VARCHAR(255),
    -- shipping address
    shipping_street VARCHAR(50),
    shipping_city VARCHAR(50),
    shipping_state_code CHAR(2),
    shipping_zipcode CHAR(5),
    -- audit
    created_by INT UNSIGNED NOT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_by_staff INT UNSIGNED,
    updated_by_customer INT UNSIGNED,
    last_updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(order_id),
    FOREIGN KEY(customer_ref) REFERENCES CUSTOMER(customer_id) ON DELETE RESTRICT,
    FOREIGN KEY(created_by) REFERENCES STAFF(staff_id) ON DELETE RESTRICT,
    -- set to arbritrary system staff
    FOREIGN KEY(updated_by_staff) REFERENCES STAFF(staff_id) ON DELETE
    SET NULL,
        -- staff updates order status etc
        FOREIGN KEY(updated_by_customer) REFERENCES CUSTOMER(customer_id) ON DELETE
    SET NULL
);
-- @block
ALTER TABLE ORDERS
ADD COLUMN tracking_number VARCHAR(50);
-- Create Meal Table
-- @block
CREATE TABLE MEAL(
    meal_id INT UNSIGNED AUTO_INCREMENT,
    meal_name VARCHAR(50) NOT NULL,
    meal_description VARCHAR(255) NOT NULL,
    meal_status BOOLEAN NOT NULL,
    nutrition_facts JSON NOT NULL,
    times_refunded INT UNSIGNED DEFAULT 0,
    start_date date NOT NULL,
    end_date date NOT NULL,
    created_by INT UNSIGNED NOT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_by INT UNSIGNED,
    last_updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    price INT UNSIGNED NOT NULL,
    cost_to_make INT UNSIGNED NOT NULL,
    PRIMARY KEY(meal_id),
    FOREIGN KEY(created_by) REFERENCES STAFF(staff_id) ON DELETE RESTRICT,
    FOREIGN KEY(updated_by) REFERENCES STAFF(staff_id) ON DELETE
    SET NULL
);
CREATE TABLE MEAL_TYPE(
    meal_type_id TINYINT UNSIGNED AUTO_INCREMENT,
    meal_type VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY(meal_type_id)
);
CREATE TABLE MEAL_TYPE_LINK(
    meal_ref INT UNSIGNED NOT NULL,
    meal_type_ref TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY(meal_ref, meal_type_ref),
    FOREIGN KEY(meal_ref) REFERENCES MEAL(meal_id) ON DELETE CASCADE,
    FOREIGN KEY(meal_type_ref) REFERENCES MEAL_TYPE(meal_type_id) ON DELETE RESTRICT
);
-- CREATE STOCK
-- @block
CREATE TABLE STOCK(
    stock_id INT UNSIGNED AUTO_INCREMENT,
    meal_ref INT UNSIGNED NOT NULL,
    quantity_in_stock INT UNSIGNED NOT NULL,
    reorder_threshold INT UNSIGNED NOT NULL,
    -- for trigger
    needs_reorder BOOLEAN NOT NULL,
    last_restock date,
    -- can be null (what if never been restocked)
    stock_fulfillment_time TINYINT UNSIGNED NOT NULL,
    -- Audit
    created_by INT UNSIGNED NOT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_by INT UNSIGNED,
    last_updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(stock_id),
    FOREIGN KEY(meal_ref) REFERENCES MEAL(meal_id) ON DELETE CASCADE,
    -- once a meal is deleted dont need stock
    FOREIGN KEY(created_by) REFERENCES STAFF(staff_id) ON DELETE RESTRICT,
    FOREIGN KEY(updated_by) REFERENCES STAFF(staff_id) ON DELETE
    SET NULL
);
-- Create Payment
-- @block
CREATE TABLE PAYMENT(
    payment_id INT UNSIGNED AUTO_INCREMENT,
    order_ref INT UNSIGNED NOT NULL UNIQUE,
    -- One payment, one order
    payment_method_ref INT UNSIGNED NOT NULL,
    payment_amount INT UNSIGNED NOT NULL,
    payment_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
    transaction_status TINYINT UNSIGNED NOT NULL,
    -- mapping this
    -- Audit
    created_by INT UNSIGNED NOT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_by INT UNSIGNED,
    last_updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(payment_id),
    FOREIGN KEY(order_ref) REFERENCES ORDERS(order_id) ON DELETE RESTRICT,
    -- this is important for historical record
    FOREIGN KEY(payment_method_ref) REFERENCES PAYMENT_METHOD(payment_method_id) ON DELETE RESTRICT,
    -- also important for records
    FOREIGN KEY(created_by) REFERENCES STAFF(staff_id) ON DELETE RESTRICT,
    FOREIGN KEY(updated_by) REFERENCES STAFF(staff_id) ON DELETE
    SET NULL
);
-- Create Sale Event
-- @block
CREATE TABLE SALE_EVENT(
    sale_event_id INT UNSIGNED AUTO_INCREMENT,
    event_name VARCHAR(50) NOT NULL,
    event_description VARCHAR(255) NOT NULL,
    event_start date NOT NULL,
    event_end date NOT NULL,
    -- Sitewide Sales
    sitewide_promo_type TINYINT UNSIGNED,
    -- nullable, mapping to percent discount, flat, etc
    sitewide_discount_value DECIMAL(4, 2),
    -- nullable, if flat multiply this value by 100 to get in cents, if percent off use the decimal
    -- Audit
    created_by INT UNSIGNED NOT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_by INT UNSIGNED,
    last_updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(sale_event_id),
    FOREIGN KEY(created_by) REFERENCES STAFF(staff_id) ON DELETE RESTRICT,
    FOREIGN KEY(updated_by) REFERENCES STAFF(staff_id) ON DELETE
    SET NULL
);
-- ORDER_LINE (ORDER-MEAL) M:N 
-- @block
CREATE TABLE ORDER_LINE(
    order_ref INT UNSIGNED NOT NULL,
    meal_ref INT UNSIGNED NOT NULL,
    num_units_ordered INT UNSIGNED NOT NULL,
    price_at_sale INT UNSIGNED NOT NULL,
    -- this is important if there was a discount on a specific meal due to sale event
    cost_per_unit INT UNSIGNED NOT NULL,
    PRIMARY KEY(order_ref, meal_ref),
    FOREIGN KEY(order_ref) REFERENCES ORDERS(order_id) ON DELETE CASCADE,
    -- if the order gets deleted no point keeping this
    FOREIGN KEY(meal_ref) REFERENCES MEAL(meal_id) ON DELETE RESTRICT -- this is important for historical record
);
-- ORDER PROMOTION M:N JUNCTION
-- @block
CREATE TABLE ORDER_PROMOTION(
    order_ref INT UNSIGNED NOT NULL,
    promotion_ref INT UNSIGNED NOT NULL,
    discount_amount INT UNSIGNED NOT NULL,
    -- for records 
    PRIMARY KEY(order_ref, promotion_ref),
    FOREIGN KEY(order_ref) REFERENCES ORDERS(order_id) ON DELETE CASCADE,
    -- if the order gets deleted this doesn't matter
    FOREIGN KEY(promotion_ref) REFERENCES PROMOTION(promotion_id) ON DELETE RESTRICT -- still want to keep this for records even if the promotion is about to be deleted
);
-- CUSTOMER MEAL M:N RELATIONSHIP BASED ON REVIEWS
-- @block
CREATE TABLE REVIEWS(
    customer_ref INT UNSIGNED NOT NULL,
    meal_ref INT UNSIGNED NOT NULL,
    stars TINYINT UNSIGNED NOT NULL,
    user_comment VARCHAR(255),
    -- nullable users can just give star rating
    PRIMARY KEY(customer_ref, meal_ref),
    FOREIGN KEY(customer_ref) REFERENCES CUSTOMER(customer_id) ON DELETE RESTRICT,
    -- keep the review on the website
    FOREIGN KEY(meal_ref) REFERENCES MEAL(meal_id) ON DELETE CASCADE -- if the meal doesn't exist the review doesn't matter
);
-- @block
CREATE TABLE MEAL_SALE(
    meal_ref INT UNSIGNED NOT NULL,
    sale_event_ref INT UNSIGNED NOT NULL,
    discount_rate DECIMAL(4, 2) NOT NULL,
    -- percentage off the specific meal
    PRIMARY KEY(meal_ref, sale_event_ref),
    FOREIGN KEY(meal_ref) REFERENCES MEAL(meal_id) ON DELETE CASCADE,
    -- if meal gets deleted sale doesnt matter
    FOREIGN KEY(sale_event_ref) REFERENCES SALE_EVENT(sale_event_id) ON DELETE CASCADE -- if sale event ends, then this meal sale doesnt matter
);