USE retail_analysis;

-- Table 1: CPI (Consumer Price Index)
CREATE TABLE cpi_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    category VARCHAR(100) NOT NULL,
    cpi DECIMAL(10, 2) NOT NULL,
    INDEX idx_date (date),
    INDEX idx_category (category)
);

-- Table 2: Retail Trade Index
CREATE TABLE retail_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    category VARCHAR(100) NOT NULL,
    retail_index DECIMAL(10, 2) NOT NULL,
    INDEX idx_date (date),
    INDEX idx_category (category)
);

-- Table 3: Consumer Confidence
CREATE TABLE consumer_confidence (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    consumer_confidence DECIMAL(10, 2) NOT NULL,
    INDEX idx_date (date)
);

-- Verify tables were created
SHOW TABLES;
