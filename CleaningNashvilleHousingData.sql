alter table nashvillehousing
add saledateconverted date;

update NashVilleHousing
set saledateconverted=CONVERT(date,saledate)

select saledateconverted, CONVERT(date,saledate) 
from [portfolio project]..NashVilleHousing

select PropertyAddress
from NashVilleHousing

select a.ParcelID ,a.PropertyAddress , b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [portfolio project]..NashVilleHousing a
join [portfolio project]..NashVilleHousing b
    on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from [portfolio project]..NashVilleHousing a
join [portfolio project]..NashVilleHousing b
    on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

select 
 PARSENAME(REPLACE(PropertyAddress,',','.'),2)
,PARSENAME(REPLACE(PropertyAddress,',','.'),1)
from [portfolio project]..NashVilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = PARSENAME(REPLACE(PropertyAddress,',','.'),2)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = PARSENAME(REPLACE(PropertyAddress,',','.'),1)

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from [portfolio project]..NashVilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
from [portfolio project]..NashVilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
CASE when SoldAsVacant = 'y' then 'yes'
     when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 end
from [portfolio project]..NashVilleHousing

update NashVilleHousing
set SoldAsVacant=CASE when SoldAsVacant = 'y' then 'yes'
     when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 end

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [portfolio project].dbo.NashvilleHousing
)
select * 
from RowNumCTE
where row_num>1

select*
From [portfolio project].dbo.NashvilleHousing

alter table [portfolio project].dbo.NashvilleHousing
drop column OwnerAddress,TaxDistrict, PropertyAddress

alter table [portfolio project].dbo.NashvilleHousing
drop column SaleDate