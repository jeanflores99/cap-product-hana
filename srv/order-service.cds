using com.training as training from '../db/training';

service ManageOrders {

    type canceledOrderReturns {
        status  : String enum {
            Succeded;
            Failed
        };
        message : String
    }


    entity GetOrders as projection on training.Orders actions {
                            function getClientTaxRate(ClientEmail : String(65)) returns Decimal(4, 2);
                            action   cancelOrder(ClientEmail : String(65))      returns canceledOrderReturns;
                        }
// function getClientTaxRate(ClientEmail : String(65)) returns Decimal(4, 2);
// action cancelOrder(ClientEmail : String(65)) returns canceledOrderReturns;
}
