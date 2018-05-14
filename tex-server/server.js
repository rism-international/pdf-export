global.__base = __dirname + '/';
var express = require('express');
var app = express();
var fs = require('fs');
const exec = require('child_process').exec;
console.log(__base);
var filePath = '/tmp/x';
var fileSize;

app.post('/raw', (req, res) => {
  if (fs.existsSync(filePath)) {
    fs.unlinkSync(filePath);
  };
  req.on('data', (data) => 
    {
      fileSize = req.headers['content-length'];
      fs.appendFile(filePath, data, function(err) {
        if(err) {
          return console.log(err);
        }
      }); 
    });
  console.log("The file was saved!");
  req.on('end', () => {
    exec('ls -ali /tmp/x', (err, stdout, stderr) => {
      if (err) {
      }
      console.log(`stdout: ${stdout}`);
    });

    res.end('Success!');

  })
});


app.listen(3000);
console.log('API is running on port 3000');
//
