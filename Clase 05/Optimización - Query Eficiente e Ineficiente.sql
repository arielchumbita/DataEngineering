------------------------------
--QUERY LENTA Y LARGA / INEFICIENTE--
--Notas: demaciados JOINs, No hay índice, no hay tabla temporal. Operación
--Set statistics hace que se demore ya que tiene que calcular.
--No hay filtros where
--Cambiar nombre de campos genera pérdida.


SET STATISTICS TIME ON --Contar tiempo ejecución
GO --Avisar que viene batch de ejecución y todo lo que esté adentro lo cuente
SELECT TOP 25
	Product.ProductID,
	Product.Name AS ProductName,
	Product.ProductNumber,
	CostMeasure.UnitMeasureCode,
	CostMeasure.Name AS CostMeasureName,
	ProductVendor.AverageLeadTime,
	ProductVendor.StandardPrice,
	ProductReview.ReviewerName,
	ProductReview.Rating,
	ProductCategory.Name AS CategoryName,
	ProductSubCategory.Name AS SubCategoryName
FROM Production.Product
INNER JOIN Production.ProductSubCategory
ON ProductSubCategory.ProductSubcategoryID = Product.ProductSubcategoryID
INNER JOIN Production.ProductCategory
ON ProductCategory.ProductCategoryID = ProductSubCategory.ProductCategoryID
INNER JOIN Production.UnitMeasure SizeUnitMeasureCode
ON Product.SizeUnitMeasureCode = SizeUnitMeasureCode.UnitMeasureCode
INNER JOIN Production.UnitMeasure WeightUnitMeasureCode
ON Product.WeightUnitMeasureCode = WeightUnitMeasureCode.UnitMeasureCode
INNER JOIN Production.ProductModel
ON ProductModel.ProductModelID = Product.ProductModelID
LEFT JOIN Production.ProductModelIllustration
ON ProductModel.ProductModelID = ProductModelIllustration.ProductModelID
LEFT JOIN Production.ProductModelProductDescriptionCulture
ON ProductModelProductDescriptionCulture.ProductModelID = ProductModel.ProductModelID
LEFT JOIN Production.ProductDescription
ON ProductDescription.ProductDescriptionID = ProductModelProductDescriptionCulture.ProductDescriptionID
LEFT JOIN Production.ProductReview
ON ProductReview.ProductID = Product.ProductID
LEFT JOIN Purchasing.ProductVendor
ON ProductVendor.ProductID = Product.ProductID
LEFT JOIN Production.UnitMeasure CostMeasure
ON ProductVendor.UnitMeasureCode = CostMeasure.UnitMeasureCode
ORDER BY Product.ProductID DESC;
SET STATISTICS TIME OFF;  --Cierro temporizador
GO --Aviso que batch se acabó

------------------------------
--QUERY R�PIDA Y CORTA / EFICIENTE--

/*
La consulta primero crea una tabla temporal denominada #Product, que incluye los 25 productos principales de la tabla
 Production.Product, junto con sus nombres, n�meros de producto, categor�a y subcategor�a de producto e ID de modelo
de producto. Los productos est�n ordenados por su ModifiedDate en orden descendente.
La segunda parte de la consulta une la tabla #Producto con otras tablas de la base de datos para recuperar informaci�n
adicional sobre cada producto. Los datos incluyen el ID del producto, el nombre del producto, el n�mero del producto,
el c�digo de la unidad de medida para el costo, el nombre de la unidad de medida, el tiempo de entrega promedio, 
el precio est�ndar, el nombre del revisor, la calificaci�n, la categor�a del producto y la subcategor�a del producto.
La consulta utiliza inner joins, left joins y alias para combinar datos de varias tablas. 
Los resultados se devuelven en formato de tabla. Finalmente, la tabla temporal se elimina al final de la consulta.
*/

SET STATISTICS TIME ON
GO
SELECT TOP 25
	Product.ProductID,
	Product.Name AS ProductName,
	Product.ProductNumber,
	ProductCategory.Name AS ProductCategory,
	ProductSubCategory.Name AS ProductSubCategory,
	Product.ProductModelID
INTO #Product --CREA TABLA TEMPORAL
FROM Production.Product
INNER JOIN Production.ProductSubCategory
ON ProductSubCategory.ProductSubcategoryID = Product.ProductSubcategoryID
INNER JOIN Production.ProductCategory
ON ProductCategory.ProductCategoryID = ProductSubCategory.ProductCategoryID
ORDER BY Product.ModifiedDate DESC;
 
SELECT
	Product.ProductID,
	Product.ProductName,
	Product.ProductNumber,
	CostMeasure.UnitMeasureCode,
	CostMeasure.Name AS CostMeasureName,
	ProductVendor.AverageLeadTime,
	ProductVendor.StandardPrice,
	ProductReview.ReviewerName,
	ProductReview.Rating,
	Product.ProductCategory,
	Product.ProductSubCategory
FROM #Product Product
INNER JOIN Production.ProductModel
ON ProductModel.ProductModelID = Product.ProductModelID
LEFT JOIN Production.ProductReview
ON ProductReview.ProductID = Product.ProductID
LEFT JOIN Purchasing.ProductVendor
ON ProductVendor.ProductID = Product.ProductID
LEFT JOIN Production.UnitMeasure CostMeasure
ON ProductVendor.UnitMeasureCode = CostMeasure.UnitMeasureCode;
 
DROP TABLE #Product;
SET STATISTICS TIME OFF;  
GO  