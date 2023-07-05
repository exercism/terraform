

'use strict';

// lambda@edge Origin Request trigger to remove the first path element
// compatible with either Node.js 6.10 or 8.10 Lambda runtime environment
//
// Taken from https://stackoverflow.com/questions/31567994/multiple-cloudfront-origins-with-behavior-path-redirection

exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.response;           // extract the response object
    const headers = response.headers;
    request.uri = request.uri.replace(/^\/[^\/]+\//,'/');  // modify the URI
    return callback(null, request);                        // return control to CloudFront
};

https://carbon.now.sh/?bg=rgba%2898%2C15%2C171%2C1%29&t=paraiso-dark&wt=none&l=auto&width=800&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=false&pv=22px&ph=30px&ln=false&fl=1&fm=Hack&fs=15px&lh=133%25&si=false&es=2x&wm=false
