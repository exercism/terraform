'use strict';

// lambda@edge Origin Request trigger to remove the first path element
// compatible with either Node.js 6.10 or 8.10 Lambda runtime environment
//
// Taken from https://stackoverflow.com/questions/31567994/multiple-cloudfront-origins-with-behavior-path-redirection

exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.request;           // extract the request object
    request.uri = request.uri.replace(/^\/[^\/]+\//,'/');  // modify the URI
    return callback(null, request);                        // return control to CloudFront
};
