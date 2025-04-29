# Famous Paintings & Museum Dataset Analysis

This repository contains SQL queries and a Python script to analyze the Famous Paintings & Museum dataset. The project focuses on solving 22 analytical problems, data cleaning, and importing CSV data into a SQL Server database.

## Dataset Overview

The dataset includes the following tables:
- `artist`: Artist details (name, nationality, etc.).
- `canvas_size`: Canvas dimensions and labels.
- `image_link`: URLs linking to painting images.
- `museum`: Museum information (name, city, country).
- `museum_hours`: Museum opening hours.
- `product_size`: Painting prices (regular and sale).
- `subject`: Subjects of paintings.
- `work`: Paintings and their metadata (artist, museum, style).

## Setup Instructions

### Dependencies
- Python 3.x
- Libraries: `pandas`, `sqlalchemy`, `pyodbc`
- SQL Server with ODBC Driver 17

### Importing Data
1. **Run the Jupyter Notebook** (`python_sql.ipynb`):
   - Updates connection strings for your SQL Server instance (replace `DESKTOP-9BP0VSB\SQLEXPRESS` with your server name).
   - Executes the script to import CSV files into the database.
   - Fix backslash issues in the server name (use raw strings or double backslashes: `r'DESKTOP-9BP0VSB\SQLEXPRESS'` or `'DESKTOP-9BP0VSB\\SQLEXPRESS'`).

### SQL Analysis
Execute the SQL script (`SQL_PROBLEMS_USING_THE_FAMOUS_PAINTINGS_&_MUSEUM_DATASET.sql`) to:
- Clean duplicate records.
- Analyze paintings, museums, and artists.
- Calculate metrics like popularity, pricing, and museum hours.

## Key SQL Problems & Solutions

1. **Undisplayed Paintments**: Identify paintings not in any museum.
2. **Empty Museums**: Find museums without paintings.
3. **Pricing Analysis**: Compare sale vs. regular prices.
4. **Canvas Size Costs**: Determine the most/least expensive canvas sizes.
5. **Museum Hours**: Identify museums open on specific days or with the longest hours.
6. **Popularity Rankings**: Top artists, museums, and painting styles.
7. **Geographical Analysis**: Countries/cities with the most museums and paintings.
8. **Data Cleaning**: Remove duplicates and fix invalid entries.

## Repository Structure

- `SQL_PROBLEMS_USING_THE_FAMOUS_PAINTINGS_&_MUSEUM_DATASET.sql`: SQL solutions for 22 analytical tasks.
- `python_sql.ipynb`: Python script to import CSV data into SQL Server.
- CSV files: Raw dataset files (e.g., `artist.csv`, `museum.csv`).

## Usage

1. **Data Import**:
   - Adjust the connection string in `python_sql.ipynb`.
   - Run all cells to upload CSV data to your database.

2. **SQL Execution**:
   - Open the SQL script in a tool like SSMS.
   - Execute queries individually or as a batch.

## Example Insights

- The most expensive painting and its museum location.
- Artists with paintings displayed in multiple countries.
- The 3 most and least popular painting styles.
- Museums open every day of the week.

---

**Note**: Ensure your SQL Server instance is running and the ODBC driver is installed. Address syntax warnings in the notebook by escaping backslashes properly. For detailed results, explore the SQL script comments.
