const cds = require("@sap/cds");
const cors = require("cors");
const AdapterProxy = require("@sap/cds-odata-v2-adapter-proxy");

cds.on("bootstrap", (app) => {
  app.use(AdapterProxy());
  app.use(cors());
  app.get("/alive", (_, res) => {
    res.status(200).send("El servidor esta activo");
  });
});

if (process.env.NODE_ENV != "production") {
  const swagger = require("cds-swagger-ui-express");
  cds.on("bootstrap", (app) => {
    app.use(swagger());
  });
  require("dotenv").config();
}
module.exports = cds.server;
