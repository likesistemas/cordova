#!/usr/bin/env node

var path = require('path');
var fs = require('fs');
var xml2js = require('xml2js');

var projectFolder = process.argv[3];
var arquivoXml = projectFolder + 'config.xml';

var projectOriginal = process.argv[2];
var packageJson = projectOriginal + 'package.json';

console.log("Arquivo Xml", arquivoXml);
console.log("Arquivo Package", packageJson);

function onError(error) {
    console.log("ERROR: " + error);
}

function xmlFileToJs(filepath, cb) {
  fs.readFile(filepath, 'utf8', function (err, xmlStr) {
      if (err) throw (err);
      xml2js.parseString(xmlStr, {}, cb);
  });
}

function jsToXmlFile(filename, obj, cb) {
  try {
    var filepath = path.normalize(path.join(__dirname, filename));
    var builder = new xml2js.Builder();
    var xml = builder.buildObject(obj);  
    console.log("Salvando o novo xml...");
    fs.writeFile(filepath, xml, cb);    
    console.log("Xml salvo em '" + filepath + "'!");
  } catch (e) {
    onError("EXCEPTION: " + e.toString());
  } 
}

function run(versaoJs) {
  console.log("Versao", versaoJs);

  xmlFileToJs(arquivoXml, function(error, data) {
    console.log("XML aberto, alterando a versão...");
    console.log("Versao Atual", data.widget.$['version']);

    var config = data;
    config.widget.$['version'] = versaoJs;

    jsToXmlFile(arquivoXml, config, function() {
      console.log("XML salvo com sucesso!");
      process.exit();
    });
  });
}

function lerVersaoJs(callback) {
  fs.readFile(packageJson, 'utf8', function (err, rawdata) {
    if (err) throw (err);

    let json = JSON.parse(rawdata);
    callback(json.version);
  });
}

lerVersaoJs(run);