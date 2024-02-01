namespace com.logali;

using {
    cuid,
    managed
} from '@sap/cds/common';

type Name    : String(50);

context materials {


    entity Products : cuid, managed {
        // key ID               : UUID;
        // Name             : String not null;
        Name             : localized String not null;
        // Description      : String;
        Description      : localized String;
        ImageUrl         : String;
        ReleaseDate      : DateTime default $now;
        DiscontinuedDate : DateTime;
        Price            : Decimal(16, 2);
        // Height           : Decimal(16, 2);
        Height           : type of Price;
        Width            : Decimal(16, 2);
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
        // Supplier_Id       : UUID;
        // ToSupplier        : Association to one Suppliers
        //                         on ToSupplier.ID = Supplier_Id;
        // UnitOfMeasures_Id : String(2);
        // toUnitOfMeasures  : Association to one UnitOfMeasures
        //                         on toUnitOfMeasures.ID = UnitOfMeasures_Id;

        // DimensionUnits_Id : String(2);
        // toDimensionUnits: Association to one DimensionUnits on toDimensionUnits.ID = DimensionUnits_Id;
        Supplier         : Association to one sales.Suppliers;
        UnitOfMeasure    : Association to one UnitOfMeasures;
        Currency         : Association to one Currencies;
        DimensionUnit    : Association to one DimensionUnits;
        Category         : Association to one Categories;
        SalesData        : Association to many sales.SalesData
                               on SalesData.Product = $self;
        Reviews          : Association to many ProductReview
                               on Reviews.Product = $self;
    }


    entity Categories {
        key ID   : String(1);
            // Name : String;
            Name : localized String;
    }

    entity StockAvailability {
        key ID          : Integer;
            // Description : String;
            Description : localized String;
            Product     : Association to one Products

    }

    entity Currencies {
        key ID          : String(3);
            // Description : String;
            Description : localized String;

    }

    entity UnitOfMeasures {
        key ID          : String(2);
            // Description : String;
            Description : localized String;

    }

    entity DimensionUnits {
        key ID          : String(2);
            // Description : String;
            Description : localized String;

    }

    entity ProjProducts  as projection on Products;

    entity ProjProducts2 as
        projection on Products {
            *
        };


    entity ProjProducts3 as
        projection on Products {
            ReleaseDate,
            Name
        };

    entity ProductReview : cuid, managed {
        // key ID           : UUID;
        Product : Association to one Products;
        // CreatedAt    : DateTime;
        Name    : String;
        Rating  : Integer;
        Comment : String;
    }

}

context sales {
    entity order : cuid {
        Date     : Date;
        Customer : String;
        Items    : Composition of many OrderItems
                       on Items.order = $self;
    }

    entity OrderItems : cuid {
        // key ID       : UUID;
        order    : Association to one order;
        product  : Association to one materials.Products;
        Quantity : Integer;
    }

    entity Suppliers : cuid, managed {
        // key ID      : UUID;
        // Name    : String;
        Name    : materials.Products:Name;
        // Street     : String;
        // City       : String;
        // State      : String(2);
        // PostalCode : String(5);
        // Country    : String(3);
        Address : Address;
        Email   : String;
        Phone   : String;
        Fax     : String;
        Product : Association to many materials.Products
                      on Product.Supplier = $self;

    }

    entity Months {
        key ID               : String(2);
            // Description      : String;
            // ShortDescription : String(3);
            Description      : localized String;
            ShortDescription : localized String(3);
    }

    entity SelfProducts  as select from materials.Products;

    entity SelfProducts1 as
        select from materials.Products {
            *
        };

    entity SelfProducts2 as
        select from materials.Products {
            Name,
            Price,
            Quantity
        };

    entity SelfProducts3 as
        select from materials.Products
        left join materials.ProductReview
            on Products.Name = ProductReview.Name
        {
            Rating,
            Products.Name,
            sum(
                Products.Price
            ) as TotalPrice
        }
        group by
            Rating,
            Products.Name
        order by
            Rating;

    entity SalesData : cuid, managed {
        // key ID            : UUID;
        DeliveryDate  : DateTime;
        Revenue       : Decimal(16, 2);
        Product       : Association to one materials.Products;
        Currency      : Association to one materials.Currencies;
        DeliveryMonth : Association to one Months;

    }
}


type Gender  : String enum {
    male;
    female;
}

type Address : {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
}


entity Car {
    key ID                 : UUID;
        name               : String;
        virtual discount_1 : Decimal;
        virtual discount_2 : Decimal;
}


//Ampliacion
extend materials.Products with {
    PriceCondition     : String(2);
    PriceDetermination : String(3);

};

context Reports {

    entity AverageRating as
        select from logali.materials.ProductReview {
            Product.ID  as ProductId,
            avg(Rating) as AverageRating : Decimal(16, 2)
        }
        group by
            Product.ID;

    entity Products      as
        select from logali.materials.Products
        mixin {
            toStockAvailibilty : Association to one logali.materials.StockAvailability
                                     on toStockAvailibilty.ID = $projection.StockAvailability;
            toAverageRating    : Association to one AverageRating
                                     on toAverageRating.ProductId = ID;
        }

        into {
            *,
            toAverageRating.AverageRating as Rating,
            case
                when
                    Quantity >= 8
                then
                    3
                when
                    Quantity > 0
                then
                    2
                else
                    1
            end                           as StockAvailability : Integer,
            toStockAvailibilty
        }
}
