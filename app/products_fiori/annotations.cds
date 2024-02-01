using CatalogService as service from '../../srv/logali-service';

annotate service.Products with @(
    Capabilities      : {DeleteRestrictions: {
        $Type    : 'Capabilities.DeleteRestrictionsType',
        Deletable: false
    }},
    UI.HeaderInfo     : {
        TypeName      : '{i18n>Product}',
        TypeNamePlural: '{i18n>Products}',
        ImageUrl      : ImageUrl,
        Title         : {Value: ProductName},
        Description   : {Value: Description}
    },
    UI.SelectionFields: [
        CategoryID,
        CurrencyID,
        StockAvailability
    ],
    UI.LineItem       : [
        {
            $Type: 'UI.DataField',
            Label: '{i18n>ImageUrl}',
            Value: ImageUrl
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>ProductName}',
            Value: ProductName
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>Description}',
            Value: Description
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Label : '{i18n>ImageUrl}',
            Target: 'Supplier/@Communication.Contact'
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>ReleaseDate}',
            Value: ReleaseDate
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>DiscontinuedDate}',
            Value: DiscontinuedDate
        },

        {
            $Type: 'UI.DataField',
            Label: '{i18n>Width}',
            Value: Width
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>Depth}',
            Value: Depth
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>Quantity}',
            Value: Quantity
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>ToCategory_ID}',
            Value: ToCategory_ID
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>ToCurrency_ID}',
            Value: ToCurrency_ID
        },
        {
            Label      : '{i18n>StockAvailability}',
            Value      : StockAvailability,
            Criticality: StockAvailability
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>Price}',
            Value: Price
        },
        {
            // $Type: 'UI.DataField',
            Label : 'Rating',
            $Type : 'UI.DataFieldForAnnotation',
            // Value : Rating,
            Target: '@UI.DataPoint#AverageRating'
        },

    ]

);

annotate service.Products with {
    StockAvailability @title: '{i18n>StockAvailability}';
    CategoryID        @title: '{i18n>CategoryID}';
    CurrencyID        @title: '{i18n>CurrencyID}';
}

annotate service.Products with @(
    UI.FieldGroup #GeneratedGroup1: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: '{i18n>ProductName}',
                Value: ProductName
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Description}',
                Value: Description
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>ImageUrl}',
                Value: ImageUrl
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>ReleaseDate}',
                Value: ReleaseDate
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>DiscontinuedDate}',
                Value: DiscontinuedDate
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Quantity}',
                Value: Quantity
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>ToCategory_ID}',
                Value: ToCategory_ID
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>ToCurrency_ID}',
                Value: ToCurrency_ID
            },
            {
                Label      : '{i18n>StockAvailability}',
                Value      : StockAvailability,
                Criticality: StockAvailability
            },
            {
                // $Type: 'UI.DataField',
                Label : 'Rating',
                // Value : Rating,
                $Type : 'UI.DataFieldForAnnotation',
                // Value : Rating,
                Target: '@UI.DataPoint#AverageRating'
            },
            {
                $Type: 'UI.DataField',
                Label: 'Price',
                Value: Price
            },
        ]
    },
    UI.Facets                     : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : 'Datos generales',
            Target: '@UI.FieldGroup#GeneratedGroup1'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet2',
            Label : 'Datos generales Copia',
            Target: '@UI.FieldGroup#GeneratedGroup1'
        }
    ],
    UI.HeaderFacets               : [{
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.DataPoint#AverageRating'
    }]
);

annotate service.Products with {
    ImageUrl @(UI.IsImageURL)
}

//Ayuda de busqueda
annotate service.Products with {
    //Filter to category
    CategoryID        @(Common: {
        Text     : {
            $value                : Category,
            ![@UI.TextArrangement]: #TextOnly,
        },
        ValueList: {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Categories',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: CategoryID,
                    ValueListProperty: 'Code'
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: Category,
                    ValueListProperty: 'Text'
                },
            ]
        },
    });
    CurrencyID        @(Common: {
                                 // ValueListWithFixedValues,
                                ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'VH_Currencies',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: CurrencyID,
                ValueListProperty: 'Code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Text'
            },
        ]
    }, });

    StockAvailability @(Common: {
        ValueListWithFixedValues,
        ValueList: {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'StockAvailability',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: StockAvailability,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Description'
                },
            ]
        },
    });

}

//Annotations para VH_categories entity

annotate service.VH_Categories with {
    Code @(
        UI    : {Hidden: true},
        Common: {Text: {
            $value                : Text,
            ![@UI.TextArrangement]: #TextOnly,
        }, }
    );
// Text @(UI: {HiddenFilter: true});

}


//Annotations para VH_Currencies entity

annotate service.VH_Currencies with {
    Code @(
        UI    : {Hidden: true},
        Common: {Text: {
            $value                : Text,
            ![@UI.TextArrangement]: #TextOnly,
        }, }
    );
// Text @(UI: {HiddenFilter: true});

}

annotate service.StockAvailability with {

    ID          @(UI: {HiddenFilter});
    Description @(UI: {HiddenFilter})

}


//annotations for supplier entity
annotate service.Supplier with @(Communication: {Contact: {
    $Type: 'Communication.ContactType',
    fn   : Name,
    role : 'Supplier',
    photo: 'sap-icon://supplier',
    email: [{
        type   : #work,
        address: Email
    }],
    tel  : [
        {
            type: #work,
            uri : Phone
        },
        {
            type: #fax,
            uri : Fax
        }
    ]
}});


//data point for average rating
annotate service.Products with @(UI.DataPoint #AverageRating: {
    Value        : Rating,
    Title        : 'Rating',
    TargetValue  : 5,
    Visualization: #Rating
});
