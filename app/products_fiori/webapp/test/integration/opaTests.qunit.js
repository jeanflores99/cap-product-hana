sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'logaligroup/productsfiori/test/integration/FirstJourney',
		'logaligroup/productsfiori/test/integration/pages/ProductsList',
		'logaligroup/productsfiori/test/integration/pages/ProductsObjectPage',
		'logaligroup/productsfiori/test/integration/pages/ReviewsObjectPage'
    ],
    function(JourneyRunner, opaJourney, ProductsList, ProductsObjectPage, ReviewsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('logaligroup/productsfiori') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheProductsList: ProductsList,
					onTheProductsObjectPage: ProductsObjectPage,
					onTheReviewsObjectPage: ReviewsObjectPage
                }
            },
            opaJourney.run
        );
    }
);