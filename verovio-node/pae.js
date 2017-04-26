var path = require("path");
const jsdom = require("jsdom");
const { JSDOM  } = jsdom;
global.window = (new JSDOM(``, { runScripts: "outside-only"  })).window;

var filename = process.argv[2];
var outfile = filename.replace(/\.[^/.]+$/, ".svg")

console.log(filename);

var fs = require('fs');
eval(fs.readFileSync(path.join(__dirname, 'verovio-toolkit.js'))+'');

var vt = new verovio.toolkit();
var code = fs.readFileSync(filename,'utf8')

var svg = vt.renderData(code, {
  spacingNonLinear: 0.54,
  pageWidth: 1500,
  spacingSystem: 0.5,
  adjustPageHeight: 1,
  border: 0
});

fs.writeFile(outfile, svg, function(err) {
  if(err) {
            return console.log(err);
  }
});

