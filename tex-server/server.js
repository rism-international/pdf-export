global.__base = __dirname + '/';
var express = require('express');
var app = express();
var fs = require('fs');
const exec = require('child_process').exec;
console.log(__base);
var filePath = '/tmp/x';
var command = 'ls -ali /tmp/x';

function shellcommand(command, res, filePath, targetSize){
  function fileSizeEquals(filePath, targetSize) {
    var timer = setTimeout(function() {
      var stats = fs.statSync(filePath);
      var fileSize = stats.size;
      if (fileSize.toString() === targetSize.toString()){
        exec(command, (err, stdout, stderr) => {
          if (err) {
          }
          console.log(stdout);
        });
        clearTimeout(timer);
        res.end('Success!');
        return true;
      }
      else{
        fileSizeEquals(filePath, targetSize);
      }}, 1000)};
    fileSizeEquals(filePath, targetSize);
}

app.post('/raw', (req, res) => {
  if (fs.existsSync(filePath)) {
    fs.unlinkSync(filePath);
  };
  req.on('data', (data) => 
    {
      targetSize = req.headers['content-length'];
      fs.appendFile(filePath, data, function(err) {
        if(err) {
          return console.log(err);
        }
      }); 
    });
  console.log("The file was saved!");
  req.on('end', () => {
      shellcommand(command, res, filePath, targetSize);
  })
});

app.listen(3000);
console.log('API is running on port 3000');
