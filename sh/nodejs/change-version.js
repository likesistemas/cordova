#!/usr/bin/env node

var path = require('path');
var fs = require('fs');
var xml2js = require('xml2js');

var arquivoVersao = process.argv[2];
var arquivoXml = process.argv[3];
var novaVersao = process.argv[4];

console.log("Arquivo Versao", arquivoVersao);
console.log("Arquivo Xml", arquivoXml);

function onError(error) {
    console.log("ERROR: " + error);
}

function xmlFileToJs(filename, cb) {
  var filepath = path.normalize(filename);
  console.log("Lendo o xml do arquivo: " + filepath);

  fs.readFile(filepath, 'utf8', function (err, xmlStr) {
      if (err) throw (err);
      xml2js.parseString(xmlStr, {}, cb);
  });
}

function jsToXmlFile(filename, obj, cb) {
  try {
    var filepath = path.normalize(filename);
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
  if(!novaVersao) {
    novaVersao = versaoJs;
  }

  console.log("Versao", novaVersao);

  xmlFileToJs(arquivoXml, function(error, data) {
    console.log("XML aberto, alterando a versão...");
    console.log("Versao Atual", data.widget.$['version']);

    var config = data;
    config.widget.$['version'] = novaVersao;

    jsToXmlFile(arquivoXml, config, function() {
      console.log("XML salvo com sucesso!");
      process.exit();
    });
  });
}

function lerVersaoJs(callback) {
  var filename = arquivoVersao;

  var filepath = path.normalize(filename);
  console.log("Lendo o js do arquivo: " + filepath);

  fs.readFile(filepath, 'utf8', function (err, jsStr) {
    if (err) throw (err);
    
    eval(jsStr);

    callback(versaoApp);
  });
}

lerVersaoJs(run);