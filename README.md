# Nashville Housing Data Cleaning Project

This repository contains a SQL script that cleans and standardizes a dataset of Nashville housing data. The original dataset is in an Excel file called `NashvilleHousingData.xlsx`, and the cleaned data is stored in a SQL Server database.

## Data Cleaning Process

The data cleaning script is called `NashvilleHousingDataCleaning.sql`, and it performs the following operations on the original dataset:

- Establishes a consistent format for dates
- Populates property address data
- Separates address into individual columns (Address, City, State)
- Changes the values in "Sold as Vacant" column to Yes and No
- Removes duplicates
- Deletes unused columns

## Data Sources

- The original dataset is stored in an Excel file called `NashvilleHousingData.xlsx`. This file is located in the root directory of the repository.
- The cleaned dataset is stored in a SQL Server database called `ProjectPortfolio`, in a table called `NashvilleHousing`.

## How to Use

1. Clone the repository to your local machine.
2. Open `NashvilleHousingDataCleaning.sql` and run the script to clean the data.
3. The cleaned data is stored in a SQL Server database called `ProjectPortfolio`, in a table called `NashvilleHousing`. You can connect to this database and query the `NashvilleHousing` table to retrieve the cleaned data.

## Contributing

If you would like to contribute to this project, please fork the repository and create a pull request with your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.
