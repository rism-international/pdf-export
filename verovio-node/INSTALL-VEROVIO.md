Description
===========
A nodejs wrapper for serverside calling verovio to render SVG from P&E-Code. Executeable is named pae.js. 
Basic idea is to use Verovio easily without OS dependency.

Prerequisites
=============
1. Nodejs v6 and npm

Install node6
```bash
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
```

```bash
sudo apt install npm
```

2. JSDOM for standalone 

```bash
npm install
```

Usage
======
You can render directly by calling the pae.js with 
```bash
nodejs pae.js incipit.code
```

where incipit.code contains the P&E code.
This creates a file incipit.svg in the same directory as the code.file.

