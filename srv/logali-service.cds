using {com.logali as entitys} from '../db/schema';

// service LogaliService {
// entity Product           as projection on entitys.materials.Products;
// entity Supplier          as projection on entitys.sales.Suppliers;
// entity Category          as projection on entitys.materials.Categories;
// entity StockAvailability as projection on entitys.materials.StockAvailability;
// entity Currency          as projection on entitys.materials.Currencies;
// entity UnitOfMeasure     as projection on entitys.materials.UnitOfMeasures;
// entity DimensionUnit     as projection on entitys.materials.DimensionUnits;
// entity Month             as projection on entitys.sales.Months;
// entity ProductReview     as projection on entitys.materials.ProductReview;
// entity SalesData         as projection on entitys.sales.SalesData;
// entity Order             as projection on entitys.sales.order;
// entity OrderItems        as projection on entitys.sales.OrderItems;
// }
// @protocol: 'graphql'
define service CatalogService {
    // entity Products          as
    //     select from entitys.materials.Products {
    //         ID,
    //         Name          as ProductName     @mandatory,
    //         Description                      @mandatory,
    //         ImageUrl,
    //         ReleaseDate,
    //         DiscontinuedDate,
    //         Price                            @mandatory,
    //         Width,
    //         Depth,
    //         Quantity                         @mandatory @assert.range,
    //         UnitOfMeasure as ToUnitOfMeasure @mandatory,
    //         Currency      as ToCurrency      @mandatory,
    //         Category      as ToCategory      @mandatory,
    //         Category.Name as Category        @readonly,
    //         DimensionUnit as ToDimensionUnits,
    //         SalesData,
    //         Supplier,
    //         Reviews
    //     };

    entity Products          as
        select from entitys.Reports.Products {
            ID,
            Name          as ProductName     @mandatory,
            Description                      @mandatory,
            ImageUrl,
            ReleaseDate,
            DiscontinuedDate,
            Price                            @mandatory,
            Width,
            Depth,
            //*,
            Quantity                         @(
                mandatory,
                assert.range: [
                    0.00,
                    20
                ]
            ),
            UnitOfMeasure as ToUnitOfMeasure @mandatory,
            Category      as ToCategory      @mandatory,
            Category.ID   as CategoryID,
            Category.Name as Category        @readonly,
            Currency      as ToCurrency      @mandatory,
            Currency.ID   as CurrencyID,
            DimensionUnit as ToDimensionUnits,
            SalesData,
            Supplier,
            Reviews,
            Rating,
            StockAvailability,
            toStockAvailibilty
        };


    entity Supplier          as
        select from entitys.sales.Suppliers {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as toProduct
        }

    @readonly
    entity Reviews           as
        select from entitys.materials.ProductReview {

            ID,
            Name,
            Rating,
            Comment,
            createdAt,
            Product as ToProduct
        };

    @readonly
    entity SalesData         as
        select from entitys.sales.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as CurrencyKey,
            DeliveryMonth.ID          as DeliveryMonthId,
            DeliveryMonth.Description as DeliveryMonth,
            Product                   as ToProduct
        }

    @readonly
    entity StockAvailability as
        select from entitys.materials.StockAvailability {
            ID,
            Description,
            Product as ToProduct
        }

    @readonly
    entity VH_Categories     as
        select from entitys.materials.Categories {
            ID   as Code,
            Name as Text,
        };

    @readonly
    entity VH_Currencies     as
        select from entitys.materials.Currencies {
            ID          as Code,
            Description as Text
        }

    @readonly
    entity VH_UnitOfMeasure  as
        select from entitys.materials.UnitOfMeasures {
            ID          as Code,
            Description as Text
        }

    // @readonly
    // entity VH_DimensionUnits as
    //     select from entitys.materials.DimensionUnits {
    //         ID          as Code,
    //         Description as Text
    //     }


    @readonly
    entity VH_DimensionUnits as
        select
            ID          as Code,
            Description as Text
        from entitys.materials.DimensionUnits;

}

define service MyService {

    entity SuppliersProduct  as
        select from entitys.materials.Products[Name = 'Bread']{
            *,
            Name,
            Description,
            Supplier.Address
        }
        where
            Supplier.Address.PostalCode = 98074;

    entity SupplierToSales   as
        select
            Supplier.Email,
            Category.Name,
            SalesData.Currency.ID,
            SalesData.Currency.Description
        from entitys.materials.Products;


    entity EntityInfix       as
        select Supplier[Name = 'Exotic Liquids'].Phone from entitys.materials.Products
        where
            Products.Name = 'Bread';

    entity LeftJoin          as
        select Phone from entitys.materials.Products
        left join entitys.sales.Suppliers as supp
            on(
                supp.ID = Products.Supplier.ID
            )
            and supp.Name = 'Exotic Liquids'
        where
            Products.Name = 'Bread';
}

// @protocol: 'graphql'
define service Reports {
    entity AverageRating     as projection on entitys.Reports.AverageRating;

    entity EntityCasting     as
        select
            cast(
                Price as      Integer
            )     as Price,
            Price as Price2 : Integer
        from entitys.materials.Products;

    entity Exits             as
        select from entitys.materials.Products {
            Name
        }
        where
            exists Supplier[Name = 'Exotic Liquids'];

}
