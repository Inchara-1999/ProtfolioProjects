select *
from nashvillehousingdata

-- change date formate 

SELECT saledate,DATE_FORMAT(STR_TO_DATE(saledate, '%M %d, %Y'), '%Y-%m-%d') AS formatted_date
FROM nashvillehousingdata;

update nashvillehousingdata
set saledate = DATE_FORMAT(STR_TO_DATE(saledate, '%M %d, %Y'), '%Y-%m-%d');

UPDATE nashvillehousingdata
SET propertyaddress = NULL
WHERE TRIM(propertyaddress) = '';

-- Populate property address


select *
from nashvillehousingdata
-- where propertyaddress is null
order by ParcelId


select nha.parcelid, nha.propertyaddress, nhb.parcelid, nhb.propertyaddress, COALESCE(nha.propertyaddress, nhb.propertyaddress)
from nashvillehousingdata Nha
join nashvillehousingdata Nhb on 
Nha.ParcelId = Nhb.ParcelId
and Nha.uniqueId <> Nhb.uniqueId
where nha.propertyaddress is null


UPDATE nashvillehousingdata NHA
JOIN nashvillehousingdata NHB ON NHA.ParcelId = NHB.ParcelId
    AND NHA.uniqueId <> NHB.uniqueId
SET NHA.propertyaddress = COALESCE(NHA.propertyaddress, NHB.propertyaddress)
WHERE NHA.propertyaddress IS NULL

-- Breaking out Address into Individual Columns (Address, City, State)

select Propertyaddress
from nashvillehousingdata

SELECT 
SUBSTRING_INDEX(PropertyAddress, ',', 1) as address,
SUBSTRING_INDEX(PropertyAddress, ',', -1) as address
FROM nashvillehousingdata;

alter table nashvillehousingdata
add PropertySplitAddress Nvarchar(255);

update nashvillehousingdata
set PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1)

alter table nashvillehousingdata
add PropertySplitCity nvarchar (255);

update nashvillehousingdata
set PropertySplitCity = SUBSTRING_INDEX(PropertyAddress, ',', -1) 

select owneraddress
from nashvillehousingdata


ALTER TABLE nashvillehousingdata
ADD StreetAddress NVARCHAR(255),
ADD  City NVARCHAR(255),
ADD  State NVARCHAR(255);


UPDATE nashvillehousingdata
SET 
    StreetAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1),
    City = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1),
    State = SUBSTRING_INDEX(OwnerAddress, ',', -1);
    
    select *
    from nashvillehousingdata
    
ALTER TABLE nashvillehousingdata
DROP COLUMN Street_Address,
DROP COLUMN City_name,
DROP COLUMN State_name;

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
from nashvillehousingdata
group by soldasvacant
order by 2

-- Change Y and N to Yes and No in "Sold as Vacant" field

select soldasvacant,
case when soldasvacant = 'y'then 'Yes'
	 when soldasvacant = 'N'then 'No'
     else soldasvacant end
from nashvillehousingdata    

update nashvillehousingdata  
set soldasvacant = case when soldasvacant = 'y'then 'Yes'
	 when soldasvacant = 'N'then 'No'
     else soldasvacant end


-- remove duplicates

DELETE nh
FROM NashvilleHousingdata nh
JOIN (
    SELECT 
        MIN(UniqueID) AS UniqueID,
        ParcelID, 
        PropertyAddress, 
        SalePrice, 
        SaleDate, 
        LegalReference
    FROM 
        NashvilleHousingdata
    GROUP BY 
        ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
    HAVING COUNT(*) > 1
) AS to_keep 
ON nh.UniqueID > to_keep.UniqueID
AND nh.ParcelID = to_keep.ParcelID
AND nh.PropertyAddress = to_keep.PropertyAddress
AND nh.SalePrice = to_keep.SalePrice
AND nh.SaleDate = to_keep.SaleDate
AND nh.LegalReference = to_keep.LegalReference;

-- check for any duplicates

WITH RowNumCTE AS(
Select *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
PropertyAddress, SalePrice, SaleDate, LegalReference
ORDER BY
UniqueID ) row_num
From NashvilleHousingdata
-- order by ParcelID
)
select * 
From RowNumCTE
where row_num > 1
order by propertyaddress 

-- delete unused columns

select *
from NashvilleHousingdata

ALTER TABLE NashvilleHousingdata
DROP COLUMN owneraddress,
DROP COLUMN taxdistrict,
DROP COLUMN propertyaddress;

ALTER TABLE NashvilleHousingdata
DROP COLUMN saledate







































