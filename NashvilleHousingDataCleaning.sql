/*

Data Cleaning Project for Nashville Housing Data

*/

Select *
FROM ProjectPortfolio.dbo.NashvilleHousing

-----------------------------------------------------------

-- Establish a consistent format for dates

/* See how we want our dates to look like */
Select SaleDate, CONVERT(Date, SaleDate) AS ExpectedFormat
FROM ProjectPortfolio.dbo.NashvilleHousing

/* Change the format of the dates */
ALTER TABLE ProjectPortfolio.dbo.NashvilleHousing
ALTER COLUMN SaleDate Date

-----------------------------------------------------------

-- Populate property address data

/* See that each ParcelID connected to one adress */
Select ParcelID, PropertyAddress
FROM ProjectPortfolio.dbo.NashvilleHousing
ORDER BY ParcelID

/* Look at expected address by checking other rows that have same ParcelID */
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) AS ExpectedAddress
FROM ProjectPortfolio.dbo.NashvilleHousing a
	JOIN ProjectPortfolio.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


/* Populate the null property address with the expected address */
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM ProjectPortfolio.dbo.NashvilleHousing a
	JOIN ProjectPortfolio.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-----------------------------------------------------------

-- Separate address into individual columns (Address, City, State)

/* Check that the delimiter is comma */
Select PropertyAddress
FROM ProjectPortfolio.dbo.NashvilleHousing

/* See how the expected address and city column would look like */
SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS ExpectedAddress,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS ExpectedCity
FROM ProjectPortfolio.dbo.NashvilleHousing

/* Add a new column for the address */
ALTER TABLE ProjectPortfolio.dbo.NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)

/* Fill the new address column */
UPDATE ProjectPortfolio.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

/* Add a new column for the city */
ALTER TABLE ProjectPortfolio.dbo.NashvilleHousing
ADD PropertySplitCity Nvarchar(255)

/* Fill the new city column */
UPDATE ProjectPortfolio.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

/* Check the expected separated column for OwnerAddress would look like */
SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM ProjectPortfolio.dbo.NashvilleHousing

/* Create new columns for the separated OwnerAddress */
ALTER TABLE ProjectPortfolio.dbo.NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255),
OwnerSplitCity Nvarchar(255),
OwnerSplitState Nvarchar(255)

/* Fill the new column with the data */
UPDATE ProjectPortfolio.dbo.NashvilleHousing
SET OwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-----------------------------------------------------------

-- Change the values in "Sold as Vacant" column to Yes and No

/* Look at the different values in the column */
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM ProjectPortfolio.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

/* Change Y and N to Yes and No */
UPDATE ProjectPortfolio.dbo.NashvilleHousing
SET SoldAsvacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END

-----------------------------------------------------------

-- Remove duplicates

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER ( PARTITION BY ParcelID,
									 PropertyAddress,
									 SalePrice,
									 SaleDate,
									 LegalReference 
									 ORDER BY UniqueID
									 ) row_num
FROM ProjectPortfolio.dbo.NashvilleHousing
-- ORDER BY ParcelID
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1

-----------------------------------------------------------

-- Delete unused columns

/* See all the columns that could be unimportant */
SELECT *
FROM ProjectPortfolio.dbo.NashvilleHousing

/* Remove all columns that are unimportant */
ALTER TABLE ProjectPortfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

