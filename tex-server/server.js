// use:  curl -i -X POST -F "data=@example/example.tex" http://localhost:3000/raw
// for params: curl -i -X POST -F "data=@example/example.tex" -F "filename=abc" http://localhost:3000/raw
// see: https://www.w3schools.com/nodejs/nodejs_uploadfiles.asp

global.__base = __dirname + '/';
var express = require('express');
var app = express();
var fs = require('fs');
var formidable = require('formidable');
const exec = require('child_process').exec;
console.log(__base);
var filePath = '/tmp/x';
var command = 'ls -ali /tmp/x';

app.post('/raw', (req, res) => {
  var form = new formidable.IncomingForm();
  form.parse(req, function (err, fields, files) {
    var oldpath = files.data.path;
    console.log(fields);
    var newpath = '/tmp/x';
    //var newpath = fields.filename;
    fs.rename(oldpath, newpath, function (err) {
      if (err) throw err;
      exec(command, (err, stdout, stderr) => {
          if (err) {
          }
          console.log(stdout);
          res.write(stdout);
          res.end();
        });
    });
  });
});

app.listen(3000);
console.log('API is running on port 3000');
