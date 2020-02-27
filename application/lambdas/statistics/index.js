const CRUD = require("crud.js");

exports.handler = async (event, _) => {
    const decodedBody = (event.isBase64Encoded ? Buffer.from(event.body, 'base64').toString('binary') : event.body);

    const requestBody = event.httpMethod !== 'GET' ?
        JSON.parse(decodedBody) :
        event.queryStringParameters;

    let statusCode = 400;
    let body = "";

    switch (event.httpMethod) {
        case 'GET':
            body = await CRUD.readItem({
                did: requestBody.did
            });
            statusCode = 200;
            break;

        default:
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
