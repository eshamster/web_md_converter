# Web-Md-Converter

[![Circle CI](https://circleci.com/gh/eshamster/web_md_converter.svg?style=svg)](https://circleci.com/gh/eshamster/web_md_converter)

Web-Md-Converter is a markdown files converter using pandoc. This includes the templates manager.

## Version information

- Tested on ruby 2.1.0, 2.2.0, 2.3.0
- Using pandoc 1.17.0.3 in our development environment

## Web Interface

TODO: Not documented

## API

### /convert

Convert a markdown file to another file by specfied format

#### POST

- arguments

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|file|true|file object||
|output_type|true|string||
|template|false|string|The name of a registered template file|

- normal respons

- error responses

### /templates/lists

#### GET

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|-||||

***Notes: There are no arguments***


### /templates

Manage template files for various formats

#### GET

Get a template file

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|type|true|string||
|name|true|string||

#### POST

Post a new template file

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|file|true|file object||
|type|true|string||
|name|true|string||

#### DELETE

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|type|true|string||
|name|true|string||

## License

Licensed under the MIT License.
