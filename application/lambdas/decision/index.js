const CRUD = require("crud.js");

exports.handler = async (event, _) => {
    const decodedBody = (event.isBase64Encoded ? Buffer.from(event.body, 'base64').toString('binary') : event.body);

    const requestBody = event.httpMethod !== 'GET' ?
        JSON.parse(decodedBody) :
        event.queryStringParameters;

    let statusCode = 400;
    let body = "Done!";

    switch (event.httpMethod) {
        case 'POST':
            await Promise.allSettled(requestBody.decisions.map(async decision => await CRUD.createItem({
                uid: requestBody.uid,
                did: decision.id,
                d_in: decision.input
            })));
            statusCode = 201;
            break;

        case 'PATCH':
            await Promise.allSettled(requestBody.decisions.map(async decision => await CRUD.updateItem({
                uid: requestBody.uid,
                did: decision.id,
            }, {
                d_out: decision.output
            })));
            statusCode = 200;
            break;

        default:
            body = "Unknown method!"
            break;
    }

    return {
        isBase64Encoded: false,
        headers: {
            "Content-Type": "application/json"
        },
        statusCode,
        body: JSON.stringify(body)
    };
};
