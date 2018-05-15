// use:  curl -i -X POST -F "data=@example/example.tex" http://localhost:3000/raw
// for params: curl -i -X POST -F "data=@example/example.tex" -F "filename=abc" http://localhost:3000/raw
// see: https://www.w3schools.com/nodejs/nodejs_uploadfiles.asp

global.__base = __dirname + '/';
var port = 33123
var express = require('express');
var app = express();
var fs = require('fs');
var formidable = require('formidable');
const exec = require('child_process').exec;
console.log(__base);
var filePath = '/tmp/x';
// Running twice because of TOC
var lualatex = 'cd /tmp; max_strings=1600000 hash_extra=1600000 lualatex -interaction batchmode --enable-write18 -shell-escape /tmp/example.tex; max_strings=1600000 hash_extra=1600000 lualatex -interaction batchmode --enable-write18 -shell-escape /tmp/example.tex; cd -';

app.post('/tex', (req, res) => {
  console.log("Starting latex generation....");
  //Removing old images
  exec("rm /tmp/*.svg", (err, stdout, stderr) => {
    if (err) throw err;
  });
  var form = new formidable.IncomingForm();
  form.parse(req, function (err, fields, files) {
    var oldpath = files.data.path;
    var newpath = '/tmp/example.tex';
    fs.rename(oldpath, newpath, function (err) {
      if (err) throw err;
      exec(lualatex, (err, stdout, stderr) => {
          if (err) {
          }
          console.log(stdout);
          fs.createReadStream('/tmp/example.pdf').pipe(fs.createWriteStream('/var/www/example.pdf'));
          console.log("Completed!");
          //res.setHeader('Content-type', 'application/pdf');
          //var pdf = fs.readFileSync('/tmp/example.pdf')
          res.write("Download completed PDF at http://lab.rism.info/example.pdf   ");
          res.end();
        });
    });
  });
});

app.listen(port);
console.log("Welcome to TEX-Server!");
console.log(`API is running on port ${port}`);
