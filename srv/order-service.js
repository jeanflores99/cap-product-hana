const cds = require("@sap/cds");
const { Orders } = cds.entities("com.training");
module.exports = (srv) => {


    srv.on("READ", "GetOrders", async (req) => {
        if (req.data.ClientEmail !== undefined) {
            return await SELECT.from`com.training.Orders`.where`ClientEmail = ${req.data.ClientEmail}`

        }
        return await SELECT.from(Orders)
    })


    srv.after("READ", "GetOrders", (data) => {
        return data.map((order) => order.Reviewed = true);
    })

    srv.on("CREATE", "GetOrders", async (req) => {
        //, CreateOn: new Date().toISOString().slice(0, 10)
        let returnData = await cds.transaction(req).run(
            INSERT.into(Orders).entries({
                ...req.data
            })
        ).then((resolve, reject) => {
            console.log("resolve", resolve)
            console.log("reject", reject)
            if (typeof resolve !== undefined) {
                return req.data
            } else {
                req.error(409, "Record not inserted");
            }
        }).catch((err) => {
            console.log(err)
            req.error(err.code, err.message);
        })
        return returnData;
    })


    srv.before("CREATE", "GetOrders", (req) => {
        req.data.CreateOn = new Date().toISOString().slice(0, 10)
        return req
    })



    //UPDATE

    srv.on("UPDATE", "GetOrders", async (req) => {
        let returnData = await cds.transaction(req).run([
            UPDATE(Orders, req.data.ClientEmail).set({
                FirstName: req.data.FirstName,
                LastName: req.data.LastName
            })
        ]).then((resolve, reject) => {
            console.log("resolve", resolve)
            console.log("reject", reject)
            if (resolve[0] == 0) {
                req.error(409, "Record not inserted");
            }
            if (typeof resolve !== undefined) {
                return req.data
            }
        }).catch((err) => {
            console.log(err)
            req.error(err.code, err.message);
        })
        console.log("before end", returnData)
        return returnData
    })

    //DELETE

    srv.on("DELETE", "GetOrder", async (req) => {
        let returnData = await cds.transaction(req).run(
            DELETE.from(Orders).where({
                ClientEmail: req.data.ClientEmails
            })
        ).then((resolve, reject) => {
            console.log("resolve", resolve)
            console.log("reject", reject)
            if (resolve !== 1) {
                req.error(409, "Record not found");
            }
            if (typeof resolve !== undefined) {
                return req.data
            }
        }).catch((err) => {
            console.log(err)
            req.error(err.code, err.message);
        })
        console.log("before end", returnData)
        return returnData
    })



    //functions
    srv.on("getClientTaxRate", async req => {
        //No server side-efect
        const { ClientEmail } = req.data
        const db = cds.transaction(req)
        const results = await db.read(Orders, ["Country_code"]).where({ ClientEmail: ClientEmail });
        console.log(results[0])
        switch (results[0].Country_code) {
            case "ES": return 21.5
            case "UK": return 24.6
            case "PE": return 10.0
        }
    })


    //Actions
    srv.on("cancelOrder", async req => {
        const { ClientEmail } = req.data;
        const db = srv.transaction(req);
        const results = await db.read(Orders, ["FirstName", "LastName", "Approved"]).where({ ClientEmail });
        const ReturnJSON = {
            status: "",
            message: ""
        }
        console.log(results[0])
        if (!results[0].Approved) {
            const resultUpdate = await db.update(Orders).set({ Status: 'C' }).where({ ClientEmail });
            ReturnJSON.status = "Succeded"
            ReturnJSON.message = `The Order placed by ${results[0].FirstName} ${results[0].LastName} was cancel`;
        } else {
            ReturnJSON.status = "Cancel"
            ReturnJSON.message = `The Order placed by ${results[0].FirstName} ${results[0].LastName} was NOT cancel`;
        }
        return ReturnJSON;
    })
}